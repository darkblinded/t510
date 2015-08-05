#!/bin/sh

if [ -f /writable/home/user/.config/openbox/custom.flag ]
then
    cp /writable/home/user/.config/openbox/rc.xml.original /writable/home/user/.config/openbox/rc.xml

    rm /writable/home/user/.config/openbox/custom.flag
else
    cp /writable/home/user/.config/openbox/rc.xml.custom /writable/home/user/.config/openbox/rc.xml

    touch /writable/home/user/.config/openbox/custom.flag
fi

openbox --reconfigure
