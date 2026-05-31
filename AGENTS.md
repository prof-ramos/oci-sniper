# 🤖 Agents Reference (AGENTS.md)

Este documento serve como um guia de contexto para agentes de IA (como eu, Antigravity) ou outros assistentes que precisem interagir com este repositório no futuro.

## 🎯 Objetivo do Projeto
O **OCI Sniper** é uma ferramenta para provisionamento de instâncias OCI (Oracle Cloud) do tipo *Always Free* (especialmente ARM A1) que costumam sofrer do erro `Out of host capacity`. O script principal é o `oci-sniper.sh`, que roda em um loop infinito fazendo polling da API OCI.

## 🧠 Memórias e Lições Aprendidas
Se você for um agente escalado para dar manutenção ou expandir este projeto, **LEIA PRIMEIRO** o arquivo `project_memories.md` localizado na raiz deste repositório. Lá estão registrados os erros e *pitfalls* encontrados na v1 (como problemas no instalador oficial do OCI, bugs de caminhos absolutos no SCP, e comandos SSH que travam sessões).

## 🗺️ Topologia de Deploy
O script está hospedado na VPS primária do usuário, referenciada como **Hermes**.
- **Diretório Clone:** `~/oci-sniper/`
- **Execução:** O script foi iniciado usando `nohup ./oci-sniper.sh > sniper.log 2>&1 &` e precisa continuar rodando em *background*.

## 🛠️ Comandos de Manutenção (Contexto do Agente)
Se precisar gerenciar o processo remotamente via SSH na VPS Hermes:
- **Verificar status:** `ps aux | grep oci-sniper.sh`
- **Ler logs:** `tail -n 50 ~/oci-sniper/sniper.log`
- **Matar processo:** `pkill -f oci-sniper.sh`

## 📦 Cloud Providers Suportados
1. **Oracle Cloud (OCI):** Alvo principal deste projeto (via `oci-cli`).
2. **Tencent Cloud:** Paralelamente, o usuário possui automação para Lighthouse via `tccli`. Sempre valide qual nuvem o usuário está se referindo antes de rodar comandos de CLI.
