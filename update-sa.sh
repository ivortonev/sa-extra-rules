#!/bin/bash

# VERSAO: 2020-11-06-01
# Autor: Ivo R. Tonev ivo@tonev.pro.br

DWCMD=""
TMPFILE=`/usr/bin/mktemp`
URL="https://raw.githubusercontent.com/ivortonev/sa-extra-rules/main/sa-extra.cf"
CONFFILE="/etc/mail/spamassassin/sa-extra.cf"
SEARCHSTR="WEBMAIL_SCAM"
WC="/usr/bin/wc"
CUT="/usr/bin/cut"
MV="/usr/bin/mv"
RESTART="/usr/sbin/service mailscanner restart"
CHMOD="/usr/bin/chmod 644 "

if [ -f  /usr/bin/curl ]; then
        export DWCMD="/usr/bin/curl"
else
        if [ -f  /usr/bin/wget ]; then
                export DWCMD="/usr/bin/wget"
        fi

fi

if [ -z "$DWCMD" ] ; then
        echo "Intall WGET or CURL"
        exit 1
fi


if [ $DWCMD == "/usr/bin/curl" ]; then
        $DWCMD $URL > $TMPFILE
fi

if [ $DWCMD == "/usr/bin/wget" ]; then
        $DWCMD $URL -O $TMPFILE
fi

VRFY=`$WC -l $TMPFILE | $CUT -f 1 -d " "`

if [ $VRFY -gt 100 ]; then
        $MV $TMPFILE $CONFFILE
        $CHMOD $CONFFILE
        $RESTART
fi
