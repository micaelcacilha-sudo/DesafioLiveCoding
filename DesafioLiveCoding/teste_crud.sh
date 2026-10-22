#!/bin/bash

# Define o arquivo de log
LOG_FILE="crud_result.log"

# Limpa o arquivo de log se já existir
> "$LOG_FILE"

echo "=== INICIANDO TESTE CRUD DA API DE FROTAS ($(date)) ===" | tee -a "$LOG_FILE"
echo "" >> "$LOG_FILE"

# 1. Cadastrar Veículo 1 (ID 3)
echo "--- 1. CADASTRANDO VEÍCULO 1 ---" | tee -a "$LOG_FILE"
curl -s -X POST http://localhost:3000/api/v1/veiculos \
  -H "Content-Type: application/json" \
  -d '{"placa":"ABC-9999","montadora":"Scania","modelo":"R500"}' | jq . >> "$LOG_FILE"
echo -e "\n" >> "$LOG_FILE"

# 2. Cadastrar Veículo 2 (ID 4)
echo "--- 2. CADASTRANDO VEÍCULO 2 ---" | tee -a "$LOG_FILE"
curl -s -X POST http://localhost:3000/api/v1/veiculos \
  -H "Content-Type: application/json" \
  -d '{"placa":"XYZ-7777","montadora":"Volvo","modelo":"FH 460"}' | jq . >> "$LOG_FILE"
echo -e "\n" >> "$LOG_FILE"

# 3. Atualizar Status do Veículo 1 (ID 3)
echo "--- 3. ATUALIZANDO STATUS DO VEÍCULO 3 (PATCH) ---" | tee -a "$LOG_FILE"
curl -s -X PATCH http://localhost:3000/api/v1/veiculos/3/status \
  -H "Content-Type: application/json" \
  -d '{"status":"EM_ROTA"}' | jq . >> "$LOG_FILE"
echo -e "\n" >> "$LOG_FILE"

# 4. Substituição via PUT
echo " SUBSTITUIÇÃO VIA PUT " | tee -a "$LOG_FILE"
curl -s -X PUT http://localhost:3000/api/v1/veiculos/2 \
  -H "Content-Type: application/json" \
  -d '{"placa":"SCA-5000","montadora":"Scania","modelo":"R500 Super","status":"DISPONIVEL"}' | jq . >> "$LOG_FILE"
echo -e "\n" >> "$LOG_FILE"

# 4. Deletar Veículo 2 (ID 4)
echo "--- 4. DELETANDO VEÍCULO 4 (DELETE) ---" | tee -a "$LOG_FILE"
curl -s -X DELETE http://localhost:3000/api/v1/veiculos/4 | jq . >> "$LOG_FILE"
echo -e "\n" >> "$LOG_FILE"

echo "=== TESTE FINALIZADO EM $(date)! LOG SALVO EM $LOG_FILE ===" | tee -a "$LOG_FILE"


