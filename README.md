# 🎯 OCI Sniper

[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/prof-ramos/oci-sniper/blob/main/LICENSE)
[![OCI CLI](https://img.shields.io/badge/OCI-CLI-red.svg)](https://docs.oracle.com/en-us/iaas/Content/API/Concepts/cliconcepts.htm)
[![Bash](https://img.shields.io/badge/Shell-Bash-green.svg)](https://www.gnu.org/software/bash/)

O **OCI Sniper** é um script de automação em Bash desenvolvido para contornar a falta de capacidade temporária ao provisionar instâncias *Always Free* na Oracle Cloud Infrastructure (OCI).

A região de São Paulo (`sa-saopaulo-1`), assim como outras regiões concorridas, frequentemente fica sem capacidade para as poderosas instâncias gratuitas **ARM (Ampere A1 de 4 OCPUs e 24GB de RAM)**. Quando tentamos criar manualmente, nos deparamos com o erro clássico: *Out of host capacity*.

> [!NOTE]
> **Por que não mudar de região?** Na Oracle Cloud, todos os recursos *Always Free* são atrelados permanentemente à sua **Home Region** (Região Principal), escolhida no momento da criação da conta. Essa escolha é irreversível e intransferível. Como você não pode simplesmente migrar sua cota gratuita para uma região mais vazia, automatizar a "pescaria" de uma vaga na sua Home Region congestionada acaba sendo a única saída.

Este script resolve o problema rodando em loop e enviando requisições automatizadas a cada 60 segundos via OCI CLI. Assim que a Oracle liberar um novo lote, o sniper "pesca" a vaga para você automaticamente! 🎣

> [!NOTE]
> Você pode rodar este script em qualquer ambiente Linux que tenha o OCI CLI instalado (até mesmo em uma instância Micro AMD gratuita da própria Oracle, criando um verdadeiro Sniper Bot interno).

---

## 🚀 Requisitos

- [OCI CLI](https://docs.oracle.com/en-us/iaas/Content/API/Concepts/cliconcepts.htm) instalado e autenticado (veja os arquivos em `~/.oci/config`).
- Permissões para criar instâncias de Compute no seu Compartment.
- OCIDs da sua rede e imagem desejada (Compartment, Subnet, Image).

## 💻 Como usar

> [!IMPORTANT]
> Antes de executar, você precisa editar o arquivo `oci-sniper.sh` e preencher as variáveis no topo do script com os OCIDs da sua conta (Compartment, Availability Domain, Subnet e Image).

1. Clone o repositório:
   ```bash
   git clone https://github.com/prof-ramos/oci-sniper.git
   cd oci-sniper
   ```

2. Dê permissão de execução ao script:
   ```bash
   chmod +x oci-sniper.sh
   ```

3. Execute o script em segundo plano (para que ele continue rodando mesmo se você fechar o terminal):
   ```bash
   nohup ./oci-sniper.sh > sniper.log 2>&1 &
   ```

4. Acompanhe a caçada em tempo real através dos logs:
   ```bash
   tail -f sniper.log
   ```

> [!TIP]
> **Dica de Ouro:** Você não precisa de uma VPS de terceiros para rodar isso. Crie uma máquina AMD Micro da Oracle (que nunca fica sem vaga), instale o OCI CLI nela e deixe ela rodando o OCI Sniper para pegar a máquina ARM de 24GB para você!

---

## ⚠️ Disclaimer e Cuidados com Rate-Limiting

> [!WARNING]
> Use esta ferramenta com responsabilidade! A Oracle possui sistemas rigorosos de *rate-limiting* (limite de taxa) para prevenir abusos de API. 

O script vem configurado por padrão com um `sleep 60` (espera de 60 segundos) entre as requisições. **Não diminua muito esse tempo**, pois inundar a API com requisições por segundo pode resultar no bloqueio temporário (429 Too Many Requests) ou banimento da sua conta. A paciência é a melhor arma de um Sniper.

---

## 🗺️ Deploy Ativo (VPS Hermes)

Para fins de registro, o script atualmente encontra-se em execução contínua na sua VPS **Hermes** através do clone oficial deste repositório.

- **Caminho do script na VPS:** `~/oci-sniper/oci-sniper.sh`
- **Caminho dos logs:** `~/oci-sniper/sniper.log`

**Comandos úteis na VPS:**
- Para acompanhar a execução: `tail -f ~/oci-sniper/sniper.log`
- Para interromper a caçada: `pkill -f oci-sniper.sh`
