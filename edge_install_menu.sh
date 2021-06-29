#!/bin/bash
#
##########################################################################
# Autor:     Rodrigo Costa                           			 #
# Contato:   rodrigo.costa@outlook.it                			 #
# Link:      https://github.com/rodrigolinux/install_edge		 #
# Data:      06/04/2021                              			 #
# Licença:   GPLv3                                   			 #
# Sobre:     Script que ao ser executado exibe uma janela (em Dialog)    #
#            solicitando qual formato do navegador Edge deseja instalar  #
##########################################################################
#
if [[ $EUID -ne 0 ]]; then
   echo "Deve ser executado como root." 
   echo "ex: sudo ./edge_install_menu.sh"
   exit 1
fi
#
HEIGHT=10
WIDTH=40
CHOICE_HEIGHT=4
BACKTITLE="Instalador"
TITLE="Microsoft Edge"
MENU="Escolha de acordo com seu sistema: "

OPTIONS=(1 "Pacote .deb"
         2 "Pacote .rpm")

OPT=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
case $OPT in
        1)
            echo "Instalando .deb"
			curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
			install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
			echo 'deb [arch=amd64] https://packages.microsoft.com/repos/edge stable main' > /etc/apt/sources.list.d/microsoft-edge-dev.list
			rm microsoft.gpg
			apt update
			apt install microsoft-edge-dev -y
            ;;
        2)
            echo "Instalando .rpm"
			rpm --import https://packages.microsoft.com/keys/microsoft.asc
			dnf config-manager --add-repo https://packages.microsoft.com/yumrepos/edge
			mv /etc/yum.repos.d/packages.microsoft.com_yumrepos_edge.repo /etc/yum.repos.d/microsoft-edge-dev.repo
			dnf install microsoft-edge-dev -y
            ;;
esac
