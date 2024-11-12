import functions_framework
from google.cloud import firestore
from flask import request, jsonify

# Inicializa el cliente Firestore
db = firestore.Client(project="terraform-test-441302", database="usuariosdb")
@functions_framework.http
def user_management(request):
    try:
        # Parseo del cuerpo de la solicitud si es necesario
        data = request.get_json(silent=True)

        # Define la colección de usuarios
        users_collection = db.collection('usuarios')

        # Manejo del método GET para consultar usuarios
        if request.method == 'GET':
            user_id = request.args.get('id')
            
            if user_id:
                # Obtener un usuario específico
                user_doc = users_collection.document(user_id).get()
                if user_doc.exists:
                    # Retornar el usuario y el ID
                    user_data = user_doc.to_dict()
                    user_data['id'] = user_doc.id  # Agregar el ID generado al dict
                    return jsonify(user_data), 200
                else:
                    return jsonify({'error': 'Usuario no encontrado'}), 404
            else:
                # Obtener todos los usuarios
                users = []
                for doc in users_collection.stream():
                    user_data = doc.to_dict()
                    user_data['id'] = doc.id  # Agregar el ID generado a cada usuario
                    users.append(user_data)
                return jsonify(users), 200

        elif request.method == 'POST':
            # Agregar usuario
            if not data:
                return jsonify({'error': 'Datos del usuario son requeridos'}), 400
            doc_ref = users_collection.add(data)
            # Retornar el ID del usuario recién creado
            return jsonify({'message': 'Usuario agregado', 'id': doc_ref[1].id}), 201

        elif request.method == 'PUT':
            # Actualizar usuario
            user_id = data.get('id')
            if not user_id:
                return jsonify({'error': 'ID de usuario requerido para actualizar'}), 400
            users_collection.document(user_id).set(data, merge=True)
            return jsonify({'message': 'Usuario actualizado'}), 200

        elif request.method == 'DELETE':
            # Eliminar usuario
            user_id = data.get('id')
            if not user_id:
                return jsonify({'error': 'ID de usuario requerido para eliminar'}), 400
            users_collection.document(user_id).delete()
            return jsonify({'message': 'Usuario eliminado'}), 200

        else:
            return jsonify({'error': 'Método no permitido'}), 405

    except Exception as e:
        return jsonify({'error': str(e)}), 500