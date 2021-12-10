#!/usr/bin/python3
# Funciona como comando para trazer informações do glive
# de qualquer usuário cadastrado.
# - permite trazer informações completas ou resumidas;
# - permite pesquisar o serviço através de um nome.
#
# Criado em 05/03/2020
# Autor: Leonardo Ferreira de Brito <leonardo.brito@g.globo>
# Versão: 1.0
import sys
import urllib.request
import json

# Setting High Intensity Colors
IBlack='\033[0;90m'       # Black
IRed='\033[0;91m'         # Red
IGreen='\033[0;92m'       # Green
IYellow='\033[0;93m'      # Yellow
IBlue='\033[0;94m'        # Blue
IPurple='\033[0;95m'      # Purple
ICyan='\033[0;96m'        # Cyan
IWhite='\033[0;97m'       # White
NC='\033[0m'              # Reset Colors

# Setting Global Variables
cmd_args_list = list(sys.argv)
total_cmd_args = len(cmd_args_list)
cmd = cmd_args_list[0].split('/')[-1]
last_param = cmd_args_list[-1]
clientid="developer"
url_email = f'http://be.glive.globoi.com/v2/users/email/{last_param}'
url_id = f'http://be.glive.globoi.com/v2/users/{last_param}'
url_eva_int = f'http://eva-int.globoi.com/cliente/valida/{last_param}'
header = ('Backstage-Client-Id', clientid)
servicespreventuserdeletion = [
                                1, 4, 84, 151, 309, 972, 
                                1007, 1948, 3033, 5906, 6004, 6236, 
                                6289, 6445, 6487, 6661, 6698, 6753, 
                                6759, 6760, 6767, 6778, 6807, 6828, 
                                6829, 6917, 6774, 6773, 6771, 6770, 
                                6769, 6768, 6767, 6766, 6765, 6764, 
                                6763, 6762, 6761, 6760, 6759, 6758, 
                                6757, 6756, 6755, 6754, 6753, 6752, 
                                6750, 6772, 6248, 465, 6709, 6851
                            ]

usage_msg=f'''
Usage: {cmd} <options> [<e-mail> | <globoid>] 
    Options:
    -h, --help                      show this help msg.
    -d, --data-only                 show only user data.
    -r, --resume                    main globoid information, including 
                                    services that prevent user deletion.
    -s, --services <string>         shows the specific services 
                                    according to the search 
                                    string in its description.

    Usage Examples:
        {cmd} operacao.producao@corp.globo.com
        {cmd} -d operacao.producao@corp.globo.com
        {cmd} -r operacao.producao@corp.globo.com
        {cmd} --service premiere operacao.producao@corp.globo.com
        {cmd} -s combate leonardo.brito@corp.globo.com
        {cmd} --resume -s play b61b573b-7811-4a7c-8128-5cef04386d56
        {cmd} -s "globoplay assinantes" operacaowebmedia@corp.globo.com
        {cmd} -r -s "globoplay assinantes" operacaowebmedia@corp.globo.com

'''

def main():
    info_list = get_info()
    if total_cmd_args < 2 or cmd_args_list[1] == '-h' or cmd_args_list[1] == '--help':
        print(usage_msg)
    elif ('-r' in cmd_args_list or '--resume' in cmd_args_list) and \
         ('-s' in cmd_args_list or '--service' in cmd_args_list):
        if '-s' in cmd_args_list:
            i = cmd_args_list.index('-s')
        else:
            i = cmd_args_list.index('--service')
        print(output(info_list, resume = True, service = cmd_args_list[i+1]))
    elif '-r' in cmd_args_list or '--resume' in cmd_args_list:
        print(output(info_list, resume = True))
    elif '-s' in cmd_args_list or '--service' in cmd_args_list:
        if '-s' in cmd_args_list:
            i = cmd_args_list.index('-s')
        else:
            i = cmd_args_list.index('--service')
        print(output(info_list, service = cmd_args_list[i+1]))
    elif '-d' in cmd_args_list or '--data-only' in cmd_args_list:
        print(output(info_list, data_only = True))
    else:
        print(output(info_list))

def output(info_list, resume = False, service = None, data_only = None):
    output = f'\n{IYellow}VALIDAÇÃO NA APP EVA-INT-PROD{NC}\n{IPurple}(http://eva-int.globoi.com/cliente/valida/{info_list[1]["globoId"]}){NC}\n'
    if info_list[0] == 'Não encontrado':
        output += f'{IRed}{info_list[0]}{NC}\n'
    else:
        output += f'{info_list[0]}\n'
    if resume == True:
        output += f'\n{IYellow}INFORMAÇÕES DO USUÁRIO PELO GLIVE{NC}\n'
        if info_list[1] != 'Não encontrado':
            for k,v in info_list[1].items():
                if k == 'globoId' or k == 'legacyUserId' or k == 'email' or\
                k == 'username' or k == 'fullName' or k == 'docNumber' or\
                k == 'status' or k == 'createdAt' or k == 'updatedAt' or\
                k == 'phones' or k == 'originService' or k == 'globocomEmail' or\
                k == 'globomailEmail' or k == 'alternativeEmail' or k == 'gender' or\
                k == 'docType' or k == 'contact' or k == 'birthDate' or\
                k == 'address' or k == 'optinGlobo' or k == 'blockReason' or\
                k == 'underageInfo' or k == 'optinGlobo' or k == 'blockReason':
                    output += f'{IBlue}{k}{NC}: {IGreen}{v}{NC}\n'
        else:
            output += f'{IRed}{info_list[1]}{NC}\n'
        if service == None and info_list[2] != 'Não encontrado':
            output += f'\n{IYellow}INFORMAÇÕES DETALHADAS DOS SERVIÇOS QUE IMPEDEM A EXCLUSÃO DO USUÁRIO{NC}\n'
            srvc_list = []
            for srvc in info_list[2]:
                #if 'globoplay assinantes' in srvc["description"].lower() or 'premiere' in srvc["description"].lower() or \
                #    'combate' in srvc["description"].lower() or 'valor' in srvc["description"].lower() or \
                #    'telecine' in srvc["description"].lower() or 'cartola pro' in srvc["description"].lower() or \
                #    'o globo - assinante' in srvc["description"].lower() or 'assinante' in srvc["description"].lower() or \
                #    'globomail' in srvc["description"].lower() or 'sexy' in srvc["description"].lower() or \
                #    'philos' in srvc["description"].lower() or 'globosatplay' in srvc["description"].lower() or \
                #    'família' in srvc["description"].lower() or 'cartola fc' in srvc["description"].lower() or \
                #    'globoplay mais canais' in srvc["description"].lower():
                for svc in servicespreventuserdeletion:
                    if srvc["serviceId"] == svc:
                        srvc_list.append(srvc)
                if srvc in srvc_list:          
                    for k, v in srvc.items():
                        output += f'{IBlue}{k}{NC}: {IGreen}{v}{NC}\n'
                    output += f'\n'
            if srvc_list == []:
                output += f'{IRed}Não foi encontrado senhum serviço que impeça sua exclusão{NC}\n'
        elif info_list[2] != 'Não encontrado':
            output += f'\n{IYellow}INFORMAÇÕES DETALHADAS DOS SERVIÇOS DO USUÁRIO PELO GLIVE COM A STRING {ICyan}\"{service}\" {IYellow}NA DESCRIÇÃO DO SERVIÇO{NC}\n'
            srvc_list = []
            for srvc in info_list[2]:
                if service in srvc["description"].lower():
                    srvc_list.append(srvc)
                    for k, v in srvc.items():
                        output += f'{IBlue}{k}{NC}: {IGreen}{v}{NC}\n'
                    output += f'\n'
            if srvc_list == []:
                output += f'{IRed}Não foi encontrado senhum serviço com a string \"{service}\"{NC} {IYellow}na descrição do serviço\n'                
    elif service != None:
        output += f'\n{IYellow}INFORMAÇÕES DETALHADAS DOS SERVIÇOS DO USUÁRIO PELO GLIVE COM A STRING {ICyan}\"{service}\" {IYellow}NA DESCRIÇÃO DO SERVIÇO{NC}\n'
        srvc_list = []
        for srvc in info_list[2]:
            if service in srvc["description"].lower():
                srvc_list.append(srvc)
                for k, v in srvc.items():
                    output += f'{IBlue}{k}{NC}: {IGreen}{v}{NC}\n'
                output += f'\n'
        if srvc_list == []:
            output += f'{IRed}Não foi encontrado senhum serviço com a string \"{service}\" {IYellow}na descrição do serviço{NC}\n'
    elif data_only:
        output += f'\n{IYellow}INFORMAÇÕES DO USUÁRIO PELO GLIVE{NC}\n'
        output += f'{json.dumps(info_list[1], indent=2, ensure_ascii=False)}\n'
    else:
        output += f'\n{IYellow}INFORMAÇÕES DO USUÁRIO PELO GLIVE{NC}\n'
        output += f'{json.dumps(info_list[1], indent=2, ensure_ascii=False)}\n'
        output += f'\n{IYellow}INFORMAÇÕES DETALHADAS DOS SERVIÇOS DO USUÁRIO PELO GLIVE{NC}\n'
        output += f'{json.dumps(info_list[2], indent=2, ensure_ascii=False)}\n'
    return output

def loading_info(url, url_header = None):
    req = urllib.request.Request(url)
    if url_header != None:
        req.add_header(url_header[0], url_header[1])
    try:
        r = urllib.request.urlopen(req)
        info = json.loads(r.read().decode('utf-8'))
    except:
        info = 'Não encontrado'
    return info

def get_info():
    if last_param.find('@') != -1:
        url = url_email
    else:
        url = url_id
    glive_info_dict = loading_info(url, header)
    eva_int = loading_info(url_eva_int)
    if 'legacyUserId' in glive_info_dict:
        legacy_id = glive_info_dict['legacyUserId']
        url_services = f'http://vendas-api.globoi.com:80/vendas-api/usuarios/{legacy_id}/servicos'
        services_list = loading_info(url_services, header)
        detailed_services_list = loading_info(f'http://be.glive.globoi.com/v2/users/{legacy_id}/services', header)
        for service in services_list:
            i = services_list.index(service) # to get index of service in list
            detailed_services_list[i]['description'] = service['descricao']
    else:
        detailed_services_list = 'Não encontrado'
    return [eva_int, glive_info_dict, detailed_services_list]


if __name__ == '__main__':
    main()