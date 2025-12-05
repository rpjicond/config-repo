#!/bin/bash

GATEWAY_URL="http://localhost:8080"
LOGIN_ENDPOINT="/api/auth/login"
IDENTITY_CREATE="/identity-service/api/v1/users"

USERNAME="testuser"
PASSWORD="12345678"

echo "🔹 1) Fazendo login no API Gateway..."

LOGIN_RESPONSE=$(curl -s -X POST "$GATEWAY_URL$LOGIN_ENDPOINT" \
  -H "Content-Type: application/json" \
  -d "{\"username\":\"$USERNAME\", \"password\":\"$PASSWORD\"}" \
  -D -)

# EXTRAIR ACCESS TOKEN DO HEADER Set-Cookie
ACCESS_TOKEN=$(echo "$LOGIN_RESPONSE" | grep EDUC_ACCESS_TOKEN | sed -E 's/.*EDUC_ACCESS_TOKEN=([^;]+).*/\1/')

if [ -z "$ACCESS_TOKEN" ]; then
  echo "❌ ERRO: Não foi possível extrair ACCESS TOKEN!"
  exit 1
fi

echo "✅ Login efetuado com sucesso!"
echo "🔑 Token extraído:"
echo "$ACCESS_TOKEN"
echo ""

echo "🔹 2) Testando criação de usuário no identity-service..."

TEST_RESPONSE=$(curl -i -X POST "$GATEWAY_URL$IDENTITY_CREATE" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
        "username":"novoUserTest",
        "email":"novoUserTest@educ.com",
        "firstName":"Novo",
        "lastName":"User",
        "password":"12345678",
        "userType":"STUDENT"
      }')

echo "$TEST_RESPONSE"
echo ""
echo "🎉 Teste concluído!"
