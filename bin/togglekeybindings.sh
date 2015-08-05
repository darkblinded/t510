#!/bin/sh

if [ -f /writable/home/user/.config/openbox/custom.flag ]
then
    cp /writable/home/user/.config/openbox/rc.xml.original /writable/home/user/.config/openbox/rc.xml
    cp /writable/home/user/.config/openbox/menu.xml.original /writable/home/user/.config/openbox/menu.xml

    rm /writable/home/user/.config/openbox/custom.flag
else
    cp /writable/home/user/.config/openbox/rc.xml.custom /writable/home/user/.config/openbox/rc.xml
    cp /writable/home/user/.config/openbox/menu.xml.custom /writable/home/user/.config/openbox/menu.xml

    touch /writable/home/user/.config/openbox/custom.flag
fi

openbox --reconfigure
