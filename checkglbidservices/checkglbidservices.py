#!/usr/bin/python3
# Funciona como comando para trazer informações do glive
# de qualquer usuário cadastrado.
# - permite trazer informações completas de serviços de um ou 
# mais usuarios;
# - permite verificar o status de uma determinada lista de servicos
# para um determinado usuário;
# - permite filtrar os servicos ativos a serem buscados para
# uma determinada lista de usuarios
#  
# Criado em 24/02/2021
# Autor: Leonardo Ferreira de Brito <leonardo.brito@g.globo>
# Versão: 1.0

import sys
import urllib.request
import json
import csv
from pathlib import Path

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

usage_msg=f'''
Usage: {cmd} <options> [<source_file> | <e-mails> | <globoids>]

    When used without options, it will show all detailed services for each email or globoid entered

    Options:
        -h, --help                          show this help msg

        -s, --serviceids [1,151,6778,...]   filters the services that will be shown, 
                                            must provide a list of serviceids separated by commas,
                                            but without blank spaces

        -a, --activeservices                shows only active serviceids, can be used as parameter -s


    Only one of the parameters below is required.

        source_file ------------------------>   must provide a path to an e-mail or globoid list

        e-mail ----------------------------->   must provide one or more e-mails separated by commas, 
                                                but without blank spaces

        globoid ---------------------------->   must provide one or more globoids separated by commas, 
                                                but without blank spaces             

    Usage Examples:
        {cmd} -s 151 $HOME/globoids.txt
        {cmd} -s 6445,3033,1007,151,6004,6828 -a operacao.producao@ig.com
        {cmd} a04fe263-0faf-4662-a799-d0ab267d1be4,operacaowebmedia@corp.globo.com
        {cmd} -a operacao.producao@ig.com
        {cmd} $HOME/emails.txt
'''

def main():
    duplicates_list = []
    # Mostrando a mensagem de ajuda quando necessário
    if total_cmd_args < 2 or cmd_args_list[1] == '-h' or cmd_args_list[1] == '--help' or total_cmd_args > 5:
        print(usage_msg)
    else:
        # Verificando se o ultimo argumento é um arquivo e se existem duplicatas nele
        print(f'\n{IYellow}Processing duplicates...{NC}')
        file = ""      
        if Path(last_param).is_file():
            file = read_csv_file(last_param)
            #duplicates_list = check_duplicates(file)
            #if duplicates_list != []:
            #    print(f'{IRed}Existem entradas duplicadas no arquivo informado, para continuar faça a otimização!\nSeguem entradas duplicadas:{NC}')
            #    for duplicate in duplicates_list:
            #        print(f'{IRed}{duplicate}{NC}')
        # Transformando o ultimo argumento em uma lista e verificando duplicatas nele
        else:
            user_list = last_param.split(",")
            duplicates_list = check_duplicates(user_list)
            if duplicates_list != []:
                print(f'{IRed}Existem entradas duplicadas no último argumento informado, para continuar faça a otimização!\nSeguem entradas duplicadas:{NC}')
                for duplicate in duplicates_list:
                    print(f'{IRed}{duplicate}{NC}')
        # Transformando possível argumento -s em lista e verificando duplicatas nele
        if "-s" in cmd_args_list or "--serviceids" in cmd_args_list:
            for arg in cmd_args_list:
                if "-s" in arg or "--serviceids" in arg:
                    servicesids = cmd_args_list[cmd_args_list.index(arg)+1].split(",")
                    duplicates_list = check_duplicates(servicesids)
                    if duplicates_list != []:
                        print(f'{IRed}Existem entradas duplicadas no argumento de serviços informado, para continuar faça a otimização!\nSeguem entradas duplicadas:{NC}')
                        for duplicate in duplicates_list:
                            print(f'{IRed}{duplicate}{NC}')
        # Iniciando o processamento dos argumentos
        if duplicates_list == []:
            print(f'{IGreen}No duplicates!{NC}\n')
            # Exibindo, para cada usuario, as informacoes mais restritiva/filtrada possivel
            if total_cmd_args == 5:
                if ("-s" in cmd_args_list or "--serviceids" in cmd_args_list) and ("-a" in cmd_args_list or "--activeservices" in cmd_args_list):
                    if file:
                        proccess_output(servicesids, "-a", file)
                    else:
                        proccess_output(servicesids, "-a", user_list)
                else:
                    print(usage_msg)
            # Exibindo, para cada usuario, as informacoes com a restricao/filtro de ids de servico
            elif total_cmd_args == 4:
                if "-s" in cmd_args_list or "--serviceids" in cmd_args_list:
                    if file:
                        proccess_output(servicesids, "", file)
                    else:
                        proccess_output(servicesids, "", user_list)
                else:
                    print(usage_msg)
            # Exibindo, para cada usuario, as informacoes com a restricao/filtro de servicos ativos
            elif total_cmd_args == 3:
                if "-a" in cmd_args_list or "--activeservices" in cmd_args_list:
                    if file:
                        proccess_output("", "-a", file)
                    else:
                        proccess_output("", "-a", user_list)
                else:
                    print(usage_msg)
            # Exibindo, para cada usuario, as informacoes completas de todos os servicos
            elif total_cmd_args == 2:
                if file:
                    proccess_output("", "", file)
                else:
                    proccess_output("", "", user_list)


class User:
    def __init__(self, email_or_glbid, email=None, glbid=None, legacyuserid=None, services=None):
        self.email_or_glbid = email_or_glbid
        self.email = email
        self.glbid = glbid
        self.legacyuserid = legacyuserid
        self.services = services

    def loading_info(self, url, url_header=None):
        req = urllib.request.Request(url)
        if url_header != None:
            req.add_header(url_header[0], url_header[1])
        try:
            r = urllib.request.urlopen(req,timeout=10)
            info = json.loads(r.read().decode('utf-8'))
        except:
            info = 'Not found'
        return info

    def get_info(self, info):
        clientid = "developer"
        header = ('Backstage-Client-Id', clientid)
        email_or_glbid = self.email_or_glbid
        if '@' in email_or_glbid:
            email = email_or_glbid          
            try:
                user_info = self.loading_info(f'http://be.glive.globoi.com/v2/users/email/{email}', header)
                glbid = user_info["globoId"]
                legacy_id = user_info["legacyUserId"]
            except Exception as err:
                glbid = "not found"
                legacy_id = "not found"

        else:
            glbid = email_or_glbid
            try:
                user_info = self.loading_info(f'http://be.glive.globoi.com/v2/users/{glbid}', header)
                email = user_info["email"]
                legacy_id = user_info["legacyUserId"]
            except Exception as err:
                email = "not found"
                legacy_id = "not found"
        if info == "email":
            return email
        elif info == "glbid":
            return glbid
        elif info == "legacy_id":
            return legacy_id
        elif info == "services":
            try:
                services = self.loading_info(f'http://be.glive.globoi.com/v2/users/{glbid}/services', header)
                return services
            except Exception as err:
                services = "not found"
        elif info == "serviceswithdescription":
            try:
                services = self.loading_info(f'http://be.glive.globoi.com/v2/users/{glbid}/services', header)
                serviceswithdescription = self.loading_info(f'http://vendas-api.globoi.com:80/vendas-api/usuarios/{legacy_id}/servicos', header)
                for service in serviceswithdescription:
                    i = serviceswithdescription.index(service) # to get index of service in list
                    services[i]['description'] = service['descricao']
                return services
            except Exception as err:
                services = "not found"
                serviceswithdescription = "not found"
                return services
        else:
            return "Not found"

    @property
    def email(self):
        return self._email

    @email.setter
    def email(self, value):
        value = self.get_info("email")
        self._email = value

    @property
    def glbid(self):
        return self._glbid

    @glbid.setter
    def glbid(self, value):
        value = self.get_info("glbid")
        self._glbid = value

    @property
    def legacyuserid(self):
        return self._legacyuserid

    @legacyuserid.setter
    def legacyuserid(self, value):
        value = self.get_info("legacy_id")
        self._legacyuserid = value

    @property
    def services(self):
        return self._services

    @services.setter
    def services(self, value):
        value = self.get_info("serviceswithdescription")
        self._services = value

def check_duplicates(inputed_list):
    duplicates_list = []
    for item in inputed_list:
        if isinstance(item, list):
            if inputed_list.count(item[0]) > 1 and duplicates_list.count(item[0]) == 0:
                duplicates_list.append(item[0])
        else:
            if inputed_list.count(item) > 1 and duplicates_list.count(item) == 0:
                duplicates_list.append(item)
    return duplicates_list

def read_csv_file(file_path):
    file = []
    with open(file_path, newline='', encoding='ISO-8859-1') as csvfile:
        reader = csv.reader(csvfile, dialect='excel', delimiter=',', quotechar='"')
        for row in reader:
            file.append(row)
    return file

def proccess_output(s_param, a_param, inpput_list):
    for item in inpput_list:
        if isinstance(item, list):
            user = User(item[0])
        else:
            user = User(item)
        user_services = user.services
        output = ""
        if s_param != "" and a_param != "" and inpput_list != "":
            try:
                for service in user_services:
                    if str(service["serviceId"]) in s_param and service["statusDescription"].lower() == "active":
                       output += f', {IBlue}{service["serviceId"]}{NC}-{IGreen}{service["statusDescription"]}{NC}'
            except Exception as err:
                output += f'{IRed}Services not found!{NC}'

        elif s_param == "" and a_param != "" and inpput_list != "":
            try:
                for service in user_services:
                    if service["statusDescription"].lower() == "active":
                       output += f', {IBlue}{service["serviceId"]}{NC}-{IGreen}{service["statusDescription"]}{NC}'
            except Exception as err:
                output += f'{IRed}Services not found!{NC}'
        elif s_param != "" and a_param == "" and inpput_list != "":
            output += f'\n'
            try:
                for service in user_services:
                    if str(service["serviceId"]) in s_param:
                        for k, v in service.items():
                            output += f'{IBlue}{k}{NC}: {IGreen}{v}{NC}\n'
                        output += f'\n'
            except Exception as err:
                output += f'{IRed}Services not found!{NC}\n'
        elif s_param == "" and a_param == "" and inpput_list != "":
            output += f'\n'
            try:
                for service in user_services:
                    for k, v in service.items():
                        output += f'{IBlue}{k}{NC}: {IGreen}{v}{NC}\n'
                    output += f'\n'
            except Exception as err:
                output += f'{IRed}Services not found!{NC}\n'
        if output != "" and output != "\n":
            if user.email == "not found" or user.glbid == "not found":
                print(f'glbid: {IRed}{user.glbid}{NC}, e-mail: {IRed}{user.email}{NC}{output}')
            else:
                print(f'glbid: {ICyan}{user.glbid}{NC}, e-mail: {ICyan}{user.email}{NC}{output}')

if __name__ == '__main__':
    main()    