# Scripts Produtividade

Contém scripts que ajudam no dia a dia da Operação Dados

## Dicas de Uso
### - Baixe o projeto para algum diretório ou clone o reposótório:
#### Clone with HTTPS
```
git clone https://gitlab.globoi.com/operacao_dados_globo/scripts_produtividade.git
```
#### Tornar todos os scripts executaveis:
```
chmod -R +x *
```
#### ou

### - Para tornar os scripts executáveis e adicioná-los a /usr/bin do sistema
#### No diretório raiz do projeto, execute:
```
make run
```
### - Para remover os links simbólicos dos scripts da /usr/bin do sistema
#### No diretório raiz do projeto, execute:
```
make clean
```
## Scripts para Ajudar na Produtividade de Redirects

* vimfiler
>É utilizado para entrar diretamente no arquivo de configuração de redirects, que se encontra no **filer.globoi.com**, de cada projeto **(g1, ge, gshow, etc)**.
>Esses arquivos de configuração de redirecrt servem os **FEs** do **Core**

* applyredirectinfiler
>É utilizado para testar e aplicar as configurações de redirect efetuadas nos **CONFs** que atendem aos **FEs** do **Core** de cada projeto.

* egrepredirectsinfiler
>É utilizado para executar o comando ```egrep```, remotamente, no **CONF** do projeto **(g1, ge, gshow, etc)** que fica no **filer.globoi.com**, com a finalidade de encontrrar alguma regra já configurada.

* chgcurlfromfile
>É utilizado para executar, em loop, o comando ```curl``` para cada **url** listada em um arquivo qualquer, definido a gosto, com a finalidade de obter os saltos de redirect.

## Scripts para Ajudar no Troubleshoot de Incidentes e Requisições

* infouser.py
>Lista as informações do usuário cadastrada no Glive.

* clientgloboidinfo (**.sh** e **.py**)
>É utilizado para trazer as infromações de cadastro de usuários no Glive, bem como o status no integrador (eva-int) e as infromações dos ids de serviço provisionados. Utilizando o **.py** temos opções como parametros que ajudam a filtrar os serviços buscando por uma string em suas descrições. Temos, também, o parametro ```-r``` ou ```--resume``` que traz as mesmas infromações anteriores, porém exibindo apenas os serviços que impedem o usuário buscado de ter seu cadastro excluído do Glive.

* checkglbidservices
>É utilizado para trazer as infromações dos ids de serviço provisionados de um usuário cadastrado no Glive. 

* glivezgrep
>É utilizado para efetuar buscas, através do comando ```zgrep``` em arquivos de log compactados do Glive.

* checkfamily
>É utilizado para trazer as infromações de família na **family-api** de um usuário cadastrado no Glive e também aplicar WAs pertinentes.

* rmglbid
>É utilizado para trazer as infromações de família na **frelationshoip-manager** de um usuário cadastrado no Glive e também executar o contorno caso seja identificado alguma inconsistência.

* smtpcadbzgrep
>É utilizado para trazer logs de envio de a-mails da Globo para clientes que precisam alterar ou ativar cadastro.

* getbsclientid
>É utilizado para trazer as infromações de um **client_id** cadastrado no Backstage e que geralmente aparece nos logs de transações de requests entre aplicações na empresa.

* checkconnectcli
>É utilizado para trazer as infromações de autenticação e troca de tokens entre as apps que compõe o sistema do **globoid-connect**.

* checkverpagamentos.sh
>Verifica a opcao ver pagamentos esta habilitada.

* deletemonitor.sh
>Remove a monitoração dos hosts em lote.

* delgranted.sh
>Deleta o dependente, onde owner ou próprio dependente (granted) não cosegue sair da familia.

* domainblacklist.sh
>Verifica se dominio esta presente no Black list da Globo.

* gsatmultibezegrep
>É utilizado para trazer logs de BE do **Gsatmulti** para descobrir qual conta de usuário já estaria associada a operadora de um determinado cliente que não consegue fazer essa associação com sua conta atual.

* check_blacklist
>É utilizado para checar se o domínio do cliente/solicitante encontra-se na blacklist do globoid.

## Scripts para Ajudar no Troubleshoot de Eventos

* checkssl
>É utilizado para checar o status de validade de certificado de algum domínio.

* checkingvips
>É utilizado para checar em loop o healtcheck dos principais vips que compões o ecossistema de autenticação do GloboID.

* curlinloop
>É utilizado para efetuar o comando ```curl``` infinitamento com a finalidade de checar algum endpoint de healtcheck

