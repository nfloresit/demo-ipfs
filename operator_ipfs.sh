#!/bin/bash

# Clave secreta para el cifrado
SECRET_KEY="pass123"
IPFS_URL="http://localhost:9094"
TOKEN="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJ1c2VyMTIzIiwiZXhwIjoxNzM5ODU3NjIwLCJyb2xlIjoiYWRtaW4ifQ.dmSIPOLybB9EBMoDQcbDwqXMq4bMU0FuhGO-MWkAJv8"

# Función para cifrar el archivo
cifrar() {
  local input_file="$1"
  local output_file="${input_file}.enc"

  if [ -z "$input_file" ]; then
    echo "Por favor, proporciona un archivo de entrada."
    exit 1
  fi

  # Cifrado con AES-256-CBC
  openssl enc -aes-256-cbc -salt -in "$input_file" -out "$output_file" -k "$SECRET_KEY"
  echo "Archivo cifrado: $output_file"
}

# Función para subir el archivo a IPFS
subir() {
  local input_file="$1"

  if [ -z "$input_file" ]; then
    echo "Por favor, proporciona un archivo a subir."
    exit 1
  fi

  # Subir el archivo cifrado a IPFS
  response=$(curl -X POST -F "file=@$input_file" -H "Authorization: Bearer $TOKEN" "$IPFS_URL/add")
  echo "Respuesta de IPFS: $response"
}

# Función para descifrar el archivo
descifrar() {
  local input_file="$1"
  local output_file="${input_file1%.enc}"

  if [ -z "$input_file" ]; then
    echo "Por favor, proporciona un archivo cifrado para descifrar."
    exit 1
  fi

  # Descifrar el archivo
  openssl enc -d -aes-256-cbc -in "$input_file" -out "output_file" -k "$SECRET_KEY"
  echo "Archivo descifrado: $output_file"
}

# Función para descargar un archivo desde IPFS
descargar() {
  local cid="$1"
  local output_file="$cid"

  if [ -z "$cid" ]; then
    echo "Por favor, proporciona el CID del archivo para descargar."
    exit 1
  fi

  # Descargar el archivo desde IPFS
  curl -X POST "http://localhost:9094/getfile?arg=$cid" -o "$output_file"

  echo "Archivo descargado: $output_file"

  # Verificar si el archivo tiene la extensión .enc
  if [[ "$output_file" == *.enc ]]; then
    echo "El archivo es cifrado. Procediendo a descifrar..."
    descifrar "$output_file"
  fi
}

# Verificar que el primer argumento sea válido
if [ $# -lt 2 ]; then
  echo "Uso: $0 [cifrar|subir|descifrar|descargar] <archivo>"
  exit 1
fi

# Acciones basadas en el primer argumento
case "$1" in
  cifrar)
    cifrar "$2"
    ;;
  subir)
    subir "$2"
    ;;
  descifrar)
    descifrar "$2"
    ;;
  descargar)
    descargar "$2"
    ;;
  *)
    echo "Acción no reconocida. Uso: $0 [cifrar|subir|descifrar|descargar] <archivo>"
    exit 1
    ;;
esac
