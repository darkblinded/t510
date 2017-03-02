#!/bin/sh

HOME="/writable/home/user"
BASEDIR="$(dirname $(readlink -nf "$0"))"

main(){
    fsunlock

    ntpdate pool.ntp.org

    apt-get update

    # MANDATORY ###################################################################

    # Gather install options#########################

    if yesno "Use gvim?"; then
        VIM="vim-gtk"
    else
        VIM="vim"
    fi


    # Install #######################################

    apt-get install man-db manpages coreutils build-essential git zsh sudo $VIM dmenu


    # Config ########################################

    # openbox
    ln -s $BASEDIR/bin/togglekeybindings.sh /usr/local/bin/togglekeybindings.sh
    chmod a+x /usr/local/bin/togglekeybindings.sh
    sudo -u user ln -s $BASEDIR/openbox/rc.xml.original $HOME/.config/openbox/rc.xml.original
    sudo -u user ln -s $BASEDIR/openbox/rc.xml.custom $HOME/.config/openbox/rc.xml.custom
    sudo -u user ln -s $BASEDIR/openbox/menu.xml.original $HOME/.config/openbox/menu.xml.original
    sudo -u user ln -s $BASEDIR/openbox/menu.xml.custom $HOME/.config/openbox/menu.xml.custom
    # Set read-only config files with include-statement for the *.lnk files
    # This is needed to prevent the hptc tools from altering the .xml files
    # while still being able to change the config
    rm $HOME/.config/openbox/rc.xml
    rm $HOME/.config/openbox/menu.xml
    cp $BASEDIR/openbox/rc.xml $HOME/.config/openbox/rc.xml
    cp $BASEDIR/openbox/menu.xml $HOME/.config/openbox/menu.xml
    chattr +i $HOME/.config/openbox/rc.xml
    chattr +i $HOME/.config/openbox/menu.xml
    sudo -u user /usr/local/bin/togglekeybindings.sh

    # zsh
    chsh -s /bin/zsh user

    #sudo
    groupadd wheel
    usermod -aG wheel user
    sed -i '/%root/a  %wheel ALL=(ALL) ALL' /etc/sudoers
    sed -i 's/timestamp_timeout = 0/timestamp_timeout = 4/' /etc/sudoers
    hptc-security

    # vim
    sudo -u user ln -s $BASEDIR/vim/vimrc $HOME/.vimrc


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

    apt-get install $HTOP $RANGER $DESKTOP $SCREENLOCK



    # Config ########################################

    # Enhanced desktop environment
    if [ "$DESKTOP" != "" ]; then
        # oh-my-zsh
        sudo -u user git clone https://github.com/robbyrussell/oh-my-zsh.git $HOME/.oh-my-zsh
        sudo -u user mv $HOME/.zshrc $HOME/.zshrc.original
        sudo -u user cp $HOME/.oh-my-zsh/templates/zshrc.zsh-template $HOME/.zshrc
        sudo -u user sed -i 's/ZSH_THEME="cf-magic"/ZSH_THEME="af-magic"/g' $HOME/.zshrc

        # urxvt-config
        "sudo -u user cat $BASEDIR/urxvt/Xresources >> $HOME/.Xresources"
        sudo -u user mkdir $HOME/.Xresources.d
        sudo -u user ln -s $BASEDIR/urxvt/urxvt.conf $HOME/.Xresources.d/urxvt.conf
        sudo -u user ln -s $BASEDIR/urxvt/urxvt.color $HOME/.Xresources.d/urxvt.color
        xrdb $HOME/.Xresources
        sudo -u user sed -i 's/xterm/urxvt/g' $HOME/.config/openbox/menu.xml.custom

        # autorun
        ln -s $BASEDIR/Xsession.d/44enhanced-desktop-environment /etc/X11/Xsession.d/44enhanced-desktop-environment
        ln -s $BASEDIR/Xsession.d/81enhanced-desktop-environment /etc/X11/Xsession.d/81enhanced-desktop-environment
        sed -i 's/sudo hptc-dashboard/#sudo hptc-dashboard/' /etc/X11/Xsession.d/43hptc-dashboard
        sudo -u user cp $BASEDIR/wallpaper.jpg $HOME/.conf/wallpaper.jpg

        echo To set another desktop image simply replace ~/.config/wallpaper.jpg or alter /etc/X11/Xsession.d/45enhanced-desktop-environment

        # tint2
        sudo -u user mkdir $HOME/.config/tint2
        sudo -u user mv $HOME/.config/tint2/tint2rc $HOME/.config/tint2/tint2rc.original
        sudo -u user ln -s $BASEDIR/tint2/tint2rc $HOME/.config/tint2/tint2rc
        sudo -u user ln -s $BASEDIR/tint2/hptc-kiosk.desktop $HOME/.config/tint2/hptc-kiosk.desktop
        sudo -u user ln -s $BASEDIR/tint2/hptc-search.desktop $HOME/.config/tint2/hptc-search.desktop
        sudo -u user ln -s $BASEDIR/tint2/hptc-switch-admin.desktop $HOME/.config/tint2/hptc-switch-admin.desktop

        if optyn "Disable hptc-dashboard?"; then
            sudo mv /usr/bin/hptc-dashboard /usr/bin/hptc-dashboard_
            sudo ln -s /bin/true /usr/bin/hptc-dashboard
        fi


    fi

    # i3lock
    if [ "$SCREENLOCK" != "" ]; then
        ln -s $BASEDIR/i3lock/lock /usr/local/bin/lock
        sudo -u user ln -s $BASEDIR/urxvt/urxvt.color $HOME/.config/lock.png
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
