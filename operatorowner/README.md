# Operator Owner

Segue neste repositório script ***operatorowner.sh***  para verifica o proprietario da conta atrelado ao GloboID consultado, na operadora associada,auxiliando nas SCTASKs de **Usuário desconhecido associado à Operadora** 

## Pré Requisito:

✅ **Possuir GloboID or E-mail**
      
## Buscando Log: 

### 📌 Realize o download do Script "operatorowner.sh"

    wget -c https://gitlab.globoi.com/eduardo.rodrigues/globo_operacao_dados/-/raw/master/Operator%20Owner/operatorowner.sh

### 📌 Execute o script:
    ./operatorowner.sh <E-mail or GloboID> <Ano+Mês>

>Exemplos:

>./operatorowner.sh luiz.utikava@gmail.com 202203       
>./operatorowner.sh da6a8e08-18c0-41fa-b59b-0db6c4e9d2c3 202203    

## Possiveis retorno da busca de log

### 📌 Localizado o logs:

<img src="https://gitlab.globoi.com/eduardo.rodrigues/globo_operacao_dados/-/raw/master/operatorowner/01.png" height="260">

### 📌 Não foram localizados logs para mês informado:

<img src="https://gitlab.globoi.com/eduardo.rodrigues/globo_operacao_dados/-/raw/master/operatorowner/02.png" height="100">

## Referências:
 

#
### 🔨 Equipe Operaçao Dados
- E-mail: op.dados@g.globo
- Tel.: 21-2129-6767
#
