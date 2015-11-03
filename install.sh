#!/bin/sh

HOME="/writable/home/user"

main(){
	fsunlock

	echo apt-get update
	
	# MANDATORY ###################################################################

	# Gather install options#########################

	echo apt-get install vim zsh sudo ranger 

	if yesno "Use gvim?"; then
		VIM="vim-gtk"
	else
		VIM="vim"
	fi


	#if yesno "Use gvim?"; then
	#	VIM="vim-gtk"
	#else
	#	VIM="vim"
	#fi

	# Install #######################################

	echo apt-get install man-db manpages git zsh sudo $VIM

	echo git clone https://github.com/robbyrussell/oh-my-zsh.git $HOME/.oh-my-zsh
	echo mv $HOME/.zshrc $HOME/.zshrc.original
	echo cp $HOME/.oh-my-zsh/templates/zshrc.zsh-template $HOME/.zshrc

	
	
	# Config ########################################

	# TODO chsh
	# TODO chown firefoc
	# TODO vimrc
	# TODO visudo
	

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

	if yesno "Install ranger the ncurses filebrowser?"; then
		RANGER="ranger"
	else
		RANGER=""
	fi

	if yesno "Install the enhanced desktop environment?"; then
		DESKTOP="devel tint2 dmenu rxvt-unicode"
	else
		DESKTOP=""
	fi

	# install #######################################
	
	apt-get install $RANGER $DESKTOP

	# Config ########################################

	#TODO urxvt-config
	#TODO zsh theme
	#TODO autorun
	
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

yesno(){
	if 
	while true; do
                read -p "$1 Yn " result
                case $result in
                        [Yy]*|"" ) return 0; break;;
                        [Nn]* ) return 1; break;;
                        * ) echo "Please answer 'y' or 'n'.";;
                esac
        done
}

main
