#!/usr/bin/env bash
LOCALPATH="$(pwd)"
DIR_NAME="scripts_produtividade"
if [[ $LOCALPATH == *"$DIR_NAME"* ]]; then
    for script_path in $(ls */*.sh); do
        script_name="$(echo $script_path | awk -F "/" '{print $2}')"
        cd /usr/bin
        sudo unlink $script_name
    done
    cd $LOCALPATH
    for script_path in $(ls */*.py); do
        script_name="$(echo $script_path | awk -F "/" '{print $2}')"
        cd /usr/bin
        sudo unlink $script_name
    done
    echo -e "\nSeguem os atalhos na /usr/bin do sistema:"
	sudo ls -lhart /usr/bin | egrep -i '^l.*(\.sh|\.py)'
else
    echo -e "\nNão foi possível remover os scripts da /usr/bin do sistema!"
fi