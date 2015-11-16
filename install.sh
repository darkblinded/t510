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

    echo apt-get install man-db manpages git zsh sudo $VIM dmenu


    # Config ########################################

    # openbox
    echo ln -s $BASEDIR/bin/togglekeybindings.sh /usr/local/bin/togglekeybindings.sh
    echo chmod a+x /usr/local/bin/togglekeybindings.sh
    echo sudo -u user ln -s $BASEDIR/openbox/rc.xml.original $HOME/.config/openbox/rc.xml.original
    echo sudo -u user ln -s $BASEDIR/openbox/rc.xml.custom $HOME/.config/openbox/rc.xml.custom
    echo sudo -u user ln -s $BASEDIR/openbox/menu.xml.original $HOME/.config/openbox/menu.xml.original
    echo sudo -u user ln -s $BASEDIR/openbox/menu.xml.custom $HOME/.config/openbox/menu.xml.custom
    # Set read-only config files with include-statement for the *.lnk files
    # This is needed to prevent the hptc tools from altering the .xml files
    # while still being able to change the config
    echo cp $BASEDIR/openbox/rc.xml $HOME/.config/openbox/rc.xml
    echo cp $BASEDIR/openbox/menu.xml $HOME/.config/openbox/menu.xml
    rm $HOME/.config/openbox/rc.xml
    rm $HOME/.config/openbox/menu.xml
    echo chattr +i $HOME/.config/openbox/menu.xml
    echo sudo -u user /usr/local/bin/togglekeybindings.sh

    # zsh
    echo chsh -s /bin/zsh user

    #sudo
    echo groupadd wheel
    echo usermod -aG wheel user
    echo sed -i '/%root/a  %wheel ALL=(ALL) ALL' /etc/sudoers
    echo sed -i 's/timestamp_timeout = 0/timestamp_timeout = 4/' /etc/sudoers
    echo passwd user

    # vim
    echo sudo -u user ln -s $BASEDIR/vim/vimrc $HOME/.vimrc


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
        DESKTOP="gcc tint2 feh rxvt-unicode"
        if optyn "Install the i3lock screen locker?"; then
            SCREENLOCK="i3lock imagemagick fonts-liberation"
        else
            SCREENLOCK=""
        fi
    else
        DESKTOP=""
    fi


    # install #######################################

    echo apt-get install $HTOP $RANGER $DESKTOP $SCREENLOCK



    # Config ########################################

    # Enhanced desktop environment
    if [ "$DESKTOP" != "" ]; then
        # oh-my-zsh
        echo sudo -u user git clone https://github.com/robbyrussell/oh-my-zsh.git $HOME/.oh-my-zsh
        echo sudo -u user mv $HOME/.zshrc $HOME/.zshrc.original
        echo sudo -u user cp $HOME/.oh-my-zsh/templates/zshrc.zsh-template $HOME/.zshrc
        echo sudo -u user sed -i 's/ZSH_THEME="cf-magic"/ZSH_THEME="af-magic"/g' $HOME/.zshrc

        # urxvt-config
        echo "sudo -u user cat $BASEDIR/urxvt/Xresources >> $HOME/.Xresources"
        echo sudo -u user mkdir $HOME/.Xresources.d
        echo sudo -u user ln -s $BASEDIR/urxvt/urxvt.conf $HOME/.Xresources.d/urxvt.conf
        echo sudo -u user ln -s $BASEDIR/urxvt/urxvt.color $HOME/.Xresources.d/urxvt.color
        echo xrdb $HOME/.Xresources
        echo sudo -u user sed -i 's/xterm/urxvt/g' $HOME/.config/openbox/menu.xml.custom

        # autorun
        echo ln -s $BASEDIR/Xsession.d/45enhanced-desktop-environment /etc/X11/Xsession.d/45enhanced-desktop-environment
        echo sed -i 's/sudo hptc-dashboard/#sudo hptc-dashboard/' /etc/X11/Xsession.d/43hptc-dashboard
        echo sudo -u cp $BASEDIR/wallpaper.jpg $HOME/.conf/wallpaper.jpg

        echo To set another desktop image simply replace ~/.config/wallpaper.jpg or alter /etc/X11/Xsession.d/45enhanced-desktop-environment

        # tint2
        echo sudo -u mkdir $HOME/.config/tint2
        echo sudo -u mv $HOME/.config/tint2/tint2rc $HOME/.config/tint2/tint2rc.original
        echo sudo -u ln -s $BASEDIR/tint2/tint2rc $HOME/.config/tint2/tint2rc
        echo sudo -u ln -s $BASEDIR/tint2/hptc-kiosk.desktop $HOME/.config/tint2/hptc-kiosk.desktop
        echo sudo -u ln -s $BASEDIR/tint2/hptc-search.desktop $HOME/.config/tint2/hptc-search.desktop
        echo sudo -u ln -s $BASEDIR/tint2/hptc-switch-admin.desktop $HOME/.config/tint2/hptc-switch-admin.desktop

    fi

    # i3lock
    if [ "$SCREENLOCK" != "" ]; then
        echo ln -s $BASEDIR/i3lock/lock /usr/local/bin/lock
        echo sudo -u user ln -s $BASEDIR/urxvt/urxvt.color $HOME/.config/lock.png
    fi

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
