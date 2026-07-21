#!/bin/bash

cd "$(dirname "$0")"

# Load env variables from .env file
if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
else
  echo "Error: .env file not found in $(pwd)"
  exit 1
fi

# Dynamically base64-encode the secrets (disable wrapping with -w 0)
export DATABASE_URL_BASE64=$(echo -n "$DATABASE_URL" | base64 -w 0)
export KEYCLOAK_CLIENT_SECRET_BASE64=$(echo -n "$KEYCLOAK_CLIENT_SECRET" | base64 -w 0)
export POSTGRES_PASSWORD_BASE64=$(echo -n "$POSTGRES_PASSWORD" | base64 -w 0)
export AUTH_SECRET_BASE64=$(echo -n "$AUTH_SECRET" | base64 -w 0)
export LIVEKIT_KEYS_BASE64=$(echo -n "${LIVEKIT_API_KEY}: ${LIVEKIT_API_SECRET}" | base64 -w 0)

# Generate config.yaml from the template using envsubst
if command -v envsubst >/dev/null 2>&1; then
  envsubst < config.template.yaml > config.yaml
  echo "Success: config.yaml has been generated successfully."
else
  echo "Error: envsubst is not installed."
  exit 1
fi
