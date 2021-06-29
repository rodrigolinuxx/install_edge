#!/bin/bash
#
##########################################################################
# Autor:     Rodrigo Costa                           			 #
# Contato:   rodrigo.costa@outlook.it                			 #
# Link:      https://github.com/rodrigolinux/install_edge		 #
# Data:      06/04/2021                              			 #
# Licença:   GPLv3                                   			 #
# Arquivo:   edge_install.sh						 #
# Sobre:     Script que ao ser executado solicita se deseja instalar     #
#            o navegador Edge no formato .deb ou .rpm                    #
##########################################################################
#
if [[ $EUID -ne 0 ]]; then
   echo "Deve ser executado como root." 
   echo "ex: sudo ./edge_install.sh"
   exit 1
fi
#
PS3='Selecione qual pacote deseja instalar: '
options=("deb" "rpm" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "deb")
            echo "Instalando .deb"
			curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
			install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
			echo 'deb [arch=amd64] https://packages.microsoft.com/repos/edge stable main' > /etc/apt/sources.list.d/microsoft-edge-dev.list
			rm microsoft.gpg
			apt update
			apt install microsoft-edge-dev -y
			exit 0
            ;;
        "rpm")
            echo "Instalando .rpm"
			rpm --import https://packages.microsoft.com/keys/microsoft.asc
			dnf config-manager --add-repo https://packages.microsoft.com/yumrepos/edge
			mv /etc/yum.repos.d/packages.microsoft.com_yumrepos_edge.repo /etc/yum.repos.d/microsoft-edge-dev.repo
			dnf install microsoft-edge-dev -y
			exit 0
            ;;
        "Quit")
            break
            ;;
        *) echo "opção inválida $REPLY";;
    esac
done
