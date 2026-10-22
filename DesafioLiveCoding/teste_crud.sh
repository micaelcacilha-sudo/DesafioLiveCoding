#!/bin/bash


# Define a porta passada por argumento ou usa 3000 como padrão
PORT=${1:-3000}
BASE_URL="http://localhost:${PORT}/api/v1"


echo "=========================================="
echo " Iniciando Testes na API (Porta: ${PORT})"
echo "=========================================="


# 1. Teste de Healthcheck
echo -e "\n[1/5] Testando GET /health..."
curl -s "${BASE_URL}/health" | jq .


# 2. Teste de POST (Capturando o ID dinamicamente)
echo -e "\n[2/5] Criando motorista via POST..."
RESPONSE=$(curl -s -X POST "${BASE_URL}/motoristas" \
  -H "Content-Type: application/json" \
  -d '{"nome": "Carlos Silva", "cnh": "12345678901"}')


echo "$RESPONSE" | jq .


# Extrai o ID gerado usando jq
ID=$(echo "$RESPONSE" | jq -r '.id')
echo "ID capturado dinamicamente: ${ID}"


# 3. Teste de GET individual
echo -e "\n[3/5] Consultando motorista criado (ID: ${ID})..."
curl -s "${BASE_URL}/motoristas/${ID}" | jq .


# 4. Teste de PUT
echo -e "\n[4/5] Atualizando motorista (ID: ${ID})..."
curl -s -X PUT "${BASE_URL}/motoristas/${ID}" \
  -H "Content-Type: application/json" \
  -d '{"nome": "Carlos Silva Editado", "cnh": "98765432100"}' | jq .


# 5. Teste de DELETE
echo -e "\n[5/5] Removendo motorista (ID: ${ID})..."
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" -X DELETE "${BASE_URL}/motoristas/${ID}")
echo "Status da remoção: ${HTTP_STATUS}"


echo -e "\n=========================================="
echo " Testes concluídos com sucesso!"
echo "=========================================="