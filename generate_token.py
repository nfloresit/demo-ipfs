import jwt
import datetime

with open("jwt_secret.key", "r") as f:
    secret_key = f.read().strip()

payload = {
    "sub": "user123",
    "exp": datetime.datetime.utcnow() + datetime.timedelta(hours=1),
    "role": "admin"
}

token = jwt.encode(payload, secret_key, algorithm="HS256")

print("Tu token JWT es:")
print(token)
