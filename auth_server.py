from flask import Flask, request
import jwt

app = Flask(__name__)

# Cargar clave secreta
with open("/app/jwt_secret.key", "r") as f:
    secret_key = f.read().strip()

@app.route('/validate', methods=['GET'])
def validate_token():
    auth_header = request.headers.get('Authorization')
    
    if not auth_header or not auth_header.startswith("Bearer "):
        return "Unauthorized", 401
    
    token = auth_header.split(" ")[1]
    
    try:
        jwt.decode(token, secret_key, algorithms=["HS256"])
        return "Authorized", 200
    except jwt.ExpiredSignatureError:
        return "Token expired", 401
    except jwt.InvalidTokenError:
        return "Invalid token", 401

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
