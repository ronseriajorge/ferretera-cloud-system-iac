import functions_framework
from google.cloud import firestore
from flask import request, jsonify, make_response

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
                user_doc = users_collection.document(user_id).get()
                if user_doc.exists:
                    user_data = user_doc.to_dict()
                    user_data['id'] = user_doc.id
                    response = make_response(jsonify(user_data), 200)
                else:
                    response = make_response(jsonify({'error': 'Usuario no encontrado'}), 404)
            else:
                users = []
                for doc in users_collection.stream():
                    user_data = doc.to_dict()
                    user_data['id'] = doc.id
                    users.append(user_data)
                response = make_response(jsonify(users), 200)

        elif request.method == 'POST':
            if not data:
                response = make_response(jsonify({'error': 'Datos del usuario son requeridos'}), 400)
            else:
                doc_ref = users_collection.add(data)
                response = make_response(jsonify({'message': 'Usuario agregado', 'id': doc_ref[1].id}), 201)

        elif request.method == 'PUT':
            user_id = data.get('id')
            if not user_id:
                response = make_response(jsonify({'error': 'ID de usuario requerido para actualizar'}), 400)
            else:
                users_collection.document(user_id).set(data, merge=True)
                response = make_response(jsonify({'message': 'Usuario actualizado'}), 200)

        elif request.method == 'DELETE':
            user_id = data.get('id')
            if not user_id:
                response = make_response(jsonify({'error': 'ID de usuario requerido para eliminar'}), 400)
            else:
                users_collection.document(user_id).delete()
                response = make_response(jsonify({'message': 'Usuario eliminado'}), 200)

        else:
            response = make_response(jsonify({'error': 'Método no permitido'}), 405)

        # Agregar encabezados de CORS a la respuesta
        response.headers['Access-Control-Allow-Origin'] = '*'
        response.headers['Access-Control-Allow-Methods'] = 'GET, POST, PUT, DELETE, OPTIONS'
        response.headers['Access-Control-Allow-Headers'] = 'Content-Type, Authorization'

        return response

    except Exception as e:
        response = make_response(jsonify({'error': str(e)}), 500)
        response.headers['Access-Control-Allow-Origin'] = '*'
        response.headers['Access-Control-Allow-Methods'] = 'GET, POST, PUT, DELETE, OPTIONS'
        response.headers['Access-Control-Allow-Headers'] = 'Content-Type, Authorization'
        return response