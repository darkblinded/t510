#!/bin/sh

HOME="/writable/home/user"
BASEDIR="$(dirname $(readlink -nf "$0"))"

main(){
    echo fsunlock

    echo apt-get update

    # MANDATORY ###################################################################

    # Gather install options#########################

    if yesno "Use gvim?"; then
        VIM="vim-gtk"
    else
        VIM="vim"
    fi


    # Install #######################################

    echo apt-get install man-db manpages git zsh sudo $VIM


    # Config ########################################

    # openbox
    echo sudo -u user ln -s $BASEDIR/bin/togglekeybindings.sh /usr/local/bin/togglekeybindings.sh
    echo chmod a+x /usr/local/bin/togglekeybindings.sh
    # Set root-owned links to prevent the hptc tools to change the link
	echo ln -s $HOME/.config/openbox/rc.xml.lnk $HOME/.config/openbox/menu.xml
	echo ln -s $HOME/.config/openbox/menu.xml.lnk $HOME/.config/openbox/menu.xml
    echo sudo -u user ln -s $BASEDIR/openbox/rc.xml.original $HOME/.config/openbox/rc.xml.original
    echo sudo -u user ln -s $BASEDIR/openbox/rc.xml.custom $HOME/.config/openbox/rc.xml.custom
    echo sudo -u user ln -s $BASEDIR/openbox/menu.xml.original $HOME/.config/openbox/menu.xml.original
    echo sudo -u user ln -s $BASEDIR/openbox/menu.xml.custom $HOME/.config/openbox/menu.xml.custom
    echo sudo -u user /usr/local/bin/togglekeybindings.sh

    # zsh
    echo chsh -s /bin/zsh user

    #sudo
    echo groupadd wheel
    echo usermod -aG wheel user
    echo -i sed '/%root/a  %wheel ALL=(ALL) ALL' /etc/sudoers
    echo passwd user
    # vim
    echo ln -s $BASEDIR/vim/vimrc $HOME/.vimrc


    # OPTIONAL ####################################################################

    # Gather install options#########################

    while true; do
        read -p "Do you want to install optional packages? - All(Y) Ask(a) None(n) " result
        case $result in
            [Yy]*|"" ) OPT=0; break;;
            [Aa]* ) OPT=1; break;;
            [Nn]* ) leave; break;;
            * ) echo "Please answer 'y', 'a' or 'n'.";;
        esac
    done

    if optyn "Install htop the ncurses process manager?"; then
        HTOP="htop"
    else
        HTOP=""
    fi

    if optyn "Install ranger the ncurses filebrowser?"; then
        RANGER="ranger"
    else
        RANGER=""
    fi

    if optyn "Install the enhanced desktop environment?"; then
        DESKTOP="gcc tint2 feh dmenu rxvt-unicode"
    else
        DESKTOP=""
    fi


    # install #######################################

    echo apt-get install $HTOP $RANGER $DESKTOP

    # oh-my-zsh
    if optyn "Install the enhanced desktop environment?"; then
        echo git clone https://github.com/robbyrussell/oh-my-zsh.git $HOME/.oh-my-zsh
        echo mv $HOME/.zshrc $HOME/.zshrc.original
        echo cp $HOME/.oh-my-zsh/templates/zshrc.zsh-template $HOME/.zshrc
        echo sed -i 's/ZSH_THEME="cf-magic"/ZSH_THEME="af-magic"/g' $HOME/.zshrc
    fi


    # Config ########################################

    #TODO urxvt-config
    #TODO zsh theme
    #TODO autorun
    #TODO tint2 launcher

}

leave(){
    exit
}

yesno(){
    while true; do
                read -p "$1 Yn " result
                case $result in
                        [Yy]*|"" ) return 0; break;;
                        [Nn]* ) return 1; break;;
                        * ) echo "Please answer 'y' or 'n'.";;
                esac
        done
}

optyn(){
    if [ "$OPT" = 0 ]; then
        return 0
    else
        while true; do
            read -p "$1 Yn " result
            case $result in
                [Yy]*|"" ) return 0; break;;
                [Nn]* ) return 1; break;;
                * ) echo "Please answer 'y' or 'n'.";;
            esac
        done
    fi
}

main
