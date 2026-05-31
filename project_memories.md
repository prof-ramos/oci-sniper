# Memórias do Projeto e Feedbacks (OCI Automation)

## Erros Cometidos e Armadilhas Encontradas (Pitfalls)

1. **Instalação do OCI CLI em ambientes sujos**
   - *O que aconteceu:* O script de instalação oficial da Oracle falha se a pasta de destino (`~/lib/oracle-cli`) já existir (mesmo que vazia ou quebrada). 
   - *Solução/Feedback:* Sempre adicionar um passo prévio de `rm -rf ~/lib/oracle-cli` (e na pasta `~/bin` correspondente) antes de rodar o `install.sh` via automação.

2. **Cópia bruta de configurações do OCI CLI via SCP**
   - *O que aconteceu:* Ao enviar a pasta `~/.oci` via `scp` do Mac para a VPS (Linux), o arquivo `config` levou o caminho absoluto da chave do Mac (`key_file=/Users/gabrielramos/.oci/oci_api_key.pem`). Isso quebrou o CLI na VPS.
   - *Solução/Feedback:* Ao espelhar configurações OCI entre máquinas com usuários diferentes, é obrigatório rodar um script/sed para ajustar o parâmetro `key_file` (ex: `sed -i "s|/Users/gabrielramos|/root|g" ~/.oci/config`).

3. **Background Tasks travando a sessão SSH (Nohup)**
   - *O que aconteceu:* Rodar um script via SSH com `ssh hermes 'nohup script.sh > log 2>&1 &'` travou a tarefa no agente, porque a sessão SSH continuou escutando.
   - *Solução/Feedback:* Sempre usar a flag `-f` do SSH para forçar ele a ir para background (`ssh -f hermes "sh -c 'nohup...'"`) ou usar ferramentas modernas como `tmux`.

4. **Uso da ferramenta Context7 MCP (Sintaxe)**
   - *O que aconteceu:* Erro ao chamar a tool `resolve-library-id` usando o argumento `query` (que era a sintaxe antiga).
   - *Solução/Feedback:* O argumento correto da MCP atual é `libraryName`.

5. **Ações de CI/CD em repositório limpo (CodeRabbit)**
   - *O que aconteceu:* Disparar `coderabbit review --agent` logo após fazer `git commit` sem ter arquivos pendentes (`git status` limpo) causa erro de execução (*No files found*).
   - *Solução/Feedback:* Sempre verificar com `git status` se há alterações na árvore antes de pedir revisões locais de ferramentas como CodeRabbit, ou forçar a flag que verifica todos os arquivos do repositório/commit específico.

6. **Bloqueio de Ping (ICMP) padrão na Oracle Cloud**
   - *O que aconteceu:* Ao tentar testar a latência das instâncias OCI usando `ping`, o terminal retornou 100% de perda de pacotes (timeout), dando a falsa impressão de que a máquina estava offline.
   - *Solução/Feedback:* A OCI bloqueia todo tráfego ICMP por padrão nas regras de VCN (Security Lists). Agentes não devem confiar no `ping` para testes de saúde na OCI; prefira testar portas TCP específicas (ex: ssh/nc na porta 22) ou alertar o usuário sobre o bloqueio de fábrica.

7. **Instalação desatendida do Tailscale via SSH (Hanging)**
   - *O que aconteceu:* Ao rodar `sudo tailscale up` remotamente para autenticar uma nova máquina, o comando "trava" no terminal porque fica aguardando o usuário abrir a URL no navegador e confirmar, segurando a thread do agente.
   - *Solução/Feedback:* Sempre rodar o `tailscale up` como uma background task (async) e usar o `grep` nos logs da task para extrair a URL de login (`https://login.tailscale.com/a/...`), liberando o agente para avisar o usuário imediatamente.

8. **Device Approval na rede Tailscale (Falso Positivo de Sucesso)**
   - *O que aconteceu:* Mesmo após o usuário clicar no primeiro link de login do Tailscale, a máquina continuava inacessível porque o recurso de "Device Approval" estava ativado no Admin Console do Tailscale.
   - *Solução/Feedback:* Agentes devem sempre monitorar a saída completa do `tailscale up`. Se o log exibir *To approve your machine, visit (as admin)...*, é crucial avisar o usuário para acessar `login.tailscale.com/admin` e aprovar manualmente.

9. **Gerenciamento de atalhos SSH (`~/.ssh/config` com Symlinks)**
   - *O que aconteceu:* O arquivo `~/.ssh/config` do usuário é frequentemente um Symlink apontando para um repositório de `dotfiles` (ex: `~/dotfiles/ssh/.ssh/config`).
   - *Solução/Feedback:* Nunca usar redirecionamentos simples de bash (`cat <<EOF >> ~/.ssh/config`) pois isso pode quebrar symlinks ou corromper o arquivo. Use sempre as ferramentas do editor (replace_file_content) lendo o caminho resolvido primeiro.
