run:
	@ echo "\nTransformando os scripts em executável:"
	chmod -R +x .
	ls -lhart */*.sh
	ls -lhart */*.py
	@ echo "\n-----------------------------------------------------------------------"
	@ echo "\nAdicionando atalhos para os scripts na /usr/bin do sistema:"
	./config_usr_bin.sh
	@ echo ""

clean:
	@ echo "\nRemovendo os atalhos dos scripts na /usr/bin do sistema:"
	./clean_usr_bin.sh