# OCI Sniper 🎯

Script de automação para provisionar instâncias Always Free na Oracle Cloud Infrastructure (OCI).

A região de São Paulo (`sa-saopaulo-1`) da Oracle Cloud frequentemente fica sem capacidade para instâncias gratuitas ARM (Ampere A1 de 4 OCPUs e 24GB de RAM). A mensagem de erro comum é *Out of host capacity*.

Este projeto fornece um script Bash simples (`oci-sniper.sh`) que roda em loop, enviando requisições de criação de instância via OCI CLI a cada 60 segundos. Assim que os servidores da Oracle liberarem capacidade, o script captura a vaga automaticamente.

## 🚀 Requisitos

- [OCI CLI](https://docs.oracle.com/en-us/iaas/Content/API/Concepts/cliconcepts.htm) instalado e configurado (`~/.oci/config`).
- IDs da sua conta OCI (Compartment OCID, Subnet OCID, Image OCID, etc).

## 💻 Como usar

1. Edite o arquivo `oci-sniper.sh` com os seus dados (variáveis no topo do arquivo).
2. Dê permissão de execução: `chmod +x oci-sniper.sh`
3. Rode em segundo plano (com nohup ou tmux) para não depender do terminal aberto:
   ```bash
   nohup ./oci-sniper.sh > sniper.log 2>&1 &
   ```
4. Acompanhe os logs:
   ```bash
   tail -f sniper.log
   ```

## ⚠️ Aviso Legal

Use com moderação. Requisições em excesso sem um intervalo de *sleep* adequado podem fazer a Oracle bloquear sua API por rate-limiting. O padrão do script é 60 segundos, o que é seguro.
