#!/usr/bin/python3

# Criado por: Sandro Augusto 
# Time: Operação Plataformas - Dados
# Data de Criação: 26-11-2021

from sys import argv
import os
import json
import re

class bcolors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKCYAN = '\033[96m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'

regex = re.compile(
        # r'^(?:http|ftp)s?://' # http:// or https://
        r'(?:(?:[A-Z0-9](?:[A-Z0-9-]{0,61}[A-Z0-9])?\.)+(?:[A-Z]{2,6}\.?|[A-Z0-9-]{2,}\.?)|' #domain...
        r'localhost|' #localhost...
        r'\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})' # ...or ip
        r'(?::\d+)?' # optional port
        r'(?:/?|[/?]\S+)$', re.IGNORECASE)

param = argv

if not re.match(regex, param[-1]) or len(param) <= 1 or param[-1] == "-h" or len(param) > 2:
	print(bcolors.WARNING + f'Para utilizar este script, insira apenas um domínio válido em forma de parâmetro seguindo o exemplo.\n Ex.: {__file__} globo.com' + bcolors.ENDC)
else:
	if __file__ not in param[-1]:
		result = os.popen(f"curl -sS http://be.glive.globoi.com/domain/{param[-1]}/blacklist").read()
	if result == "":
		print(bcolors.OKBLUE + f'Este domínio {param[-1]} não está na blacklist!' + bcolors.ENDC)
	else:
		print(bcolors.FAIL + json.dumps(eval(result),indent=4))
		print('Dominio encontra-se em blacklist!' + bcolors.ENDC)
