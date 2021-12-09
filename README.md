# scripts_produtividade

Contém scripts que ajudam no dia a dia da Operação Dados

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

* clientgloboidinfo
>É utilizado para trazer as infromações de cadastro de usuários no Glive, bem como o status no integrador (eva-int) e as infromações dos ids de serviço provisionados.

* checkglbidservices
>É utilizado para trazer as infromações dos ids de serviço provisionados de um usuário cadastrado no Glive. 

* glivezgrep
>É utilizado para efetuar buscas, através do comando ```zgrep``` em arquivos de log compactados do Glive.

* checkfamily
>É utilizado para trazer as infromações de família na **family-api** de um usuário cadastrado no Glive.

* rmglbid
>É utilizado para trazer as infromações de família na **frelationshoip-manager** de um usuário cadastrado no Glive e também executar o contorno caso seja identificado alguma inconsistência.

* smtpcadbzgrep
>É utilizado para trazer logs de envio de a-mails da Globo para clientes que precisam alterar ou ativar cadastro.

* getbsclientid
>É utilizado para trazer as infromações de um **client_id** cadastrado no Backstage e que geralmente aparece nos logs de transações de requests entre aplicações na empresa.

* checkconnectcli
>É utilizado para trazer as infromações de autenticação e troca de tokens entre as apps que compõe o sistema do **globoid-connect**.

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
