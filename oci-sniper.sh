#!/bin/bash
# OCI Auto Provision Script for ARM Free Tier
# This script will attempt to create the instance every 60 seconds until successful.

export PYTHONWARNINGS="ignore"

COMPARTMENT_ID="ocid1.tenancy.oc1..aaaaaaaa4xttsrbhf5hb2rfjo5ul3ve2hbwt24amy5aequvczeku3d3fvgza"
AD="OdIO:SA-SAOPAULO-1-AD-1"
SUBNET_ID="ocid1.subnet.oc1.sa-saopaulo-1.aaaaaaaar37gozyj3vck3et3bjcyxu5zdkb6v4hhmcqykzrxlrcxub3sji6a"
IMAGE_ID="ocid1.image.oc1.sa-saopaulo-1.aaaaaaaaemf52b7af7ncncxz6pdc6hrlkdmylvwejfzpwnpbuhlfxwhrno6a"
SHAPE="VM.Standard.A1.Flex"
DISPLAY_NAME="arm-free-tier-24gb"

echo "=========================================================="
echo "Iniciando tentativas de provisionamento para a região sa-saopaulo-1"
echo "Alvo: ARM 4 OCPUs, 24GB RAM"
echo "=========================================================="

while true; do
    echo "[$(date)] Tentando provisionar a instância ARM..."
    
    OUTPUT=$(/root/bin/oci compute instance launch \
        --compartment-id "$COMPARTMENT_ID" \
        --availability-domain "$AD" \
        --shape "$SHAPE" \
        --shape-config '{"ocpus": 4, "memoryInGBs": 24}' \
        --subnet-id "$SUBNET_ID" \
        --image-id "$IMAGE_ID" \
        --display-name "$DISPLAY_NAME" \
        --assign-public-ip true 2>&1)
        
    if [[ "$OUTPUT" == *"Out of host capacity"* ]]; then
        echo "Falha: Sem capacidade no momento. A Oracle não tem vagas em São Paulo. Tentando novamente em 60 segundos..."
        sleep 60
    elif [[ "$OUTPUT" == *"LimitExceeded"* ]]; then
        echo "Falha: Limite de cota excedido (LimitExceeded). Você provavelmente atingiu o limite de instâncias gratuitas ou blocos."
        echo "O script será pausado para evitar bloqueio."
        break
    elif [[ "$OUTPUT" == *"opc-work-request-id"* ]] || [[ "$OUTPUT" == *"lifecycle-state"* ]]; then
        echo "=========================================================="
        echo "SUCESSO ABSOLUTO! A INSTÂNCIA FOI PROVISIONADA! 🎉"
        echo "=========================================================="
        echo "$OUTPUT"
        break
    else
        echo "Erro desconhecido ao tentar criar a instância:"
        echo "$OUTPUT"
        echo "Tentando novamente em 60 segundos por garantia..."
        sleep 60
    fi
done
