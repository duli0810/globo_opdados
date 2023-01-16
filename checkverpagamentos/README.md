# Check Ver Pagamentos

Neste procedimento será demonstrado como verificar se a ```Opção Ver Pagamentos``` esta ou não habilitada. 

⚠️ Atenção! a rota abaixo realiza uma chamada no Glive que verifica o status do usuário: 
 
 - Status ```"FREE"```, ***Opção Ver Pagamentos*** não é exibida  
 - Status ```"SALESFORCE"```, ***Opção Ver Pagamentos*** é exibida  

## Pré Requisito:

✅ **Possuir o ID**
      
## Verificando Opção Ver Pagamentos:

Informe no comando o **GloboID** do usuário:

    curl -X GET http://be.glive.globoi.com/v2/users/<GloboID>/subscription/status -H 'Backstage-Client-Id: 'developer'' -s | jq

## Referencia:
 
⭐ ["GloboID – Verificar "Opção Ver Pagamentos""](https://globoservice.service-now.com/kb_view.do?sysparm_article=KB0105502)

### ✍️ Autor

#### [Eduardo Rodrigues da Silva](https://gitlab.globoi.com/eduardo.rodrigues) 
#
### 🔨 Equipe Operaçao Dados
- E-mail: op.dados@g.globo
- Tel.: 21-2129-6767
#
