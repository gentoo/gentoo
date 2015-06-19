#!/bin/bash
# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/vpopmail/files/vpopmail-Maildir-dotmaildir-fix.sh,v 1.2 2004/10/19 17:55:24 robbat2 Exp $
# Written by Robin H. Johnson, robbat2@gentoo.org

OLDNAME='Maildir'
NEWNAME='.maildir'
SEARCHPATH=/var/vpopmail/domains/
MINDEPTH=3
# If you have a very large vpopmail deployment, you may need to increase MAXDEPTH.
MAXDEPTH=6

if [ "${1}" == '--revert' ]; then
    SEARCHNAME="${NEWNAME}"
    REPLACENAME="${OLDNAME}"
else
    SEARCHNAME="${OLDNAME}"
    REPLACENAME="${NEWNAME}"
fi

echo "Doing '${SEARCHNAME}' '${REPLACENAME}' changeover"
echo find ${SEARCHPATH} -name "${SEARCHNAME}" -maxdepth $MAXDEPTH -mindepth $MINDEPTH -type d
for i in `find ${SEARCHPATH} -name "${SEARCHNAME}" -maxdepth $MAXDEPTH -mindepth $MINDEPTH -type d`; do
    foundname=${i/${SEARCHNAME}*}${SEARCHNAME}
    base="`dirname $i`"
    todoname=${base}/${REPLACENAME}
	#echo "$foundname -> $todoname"
    echo "Fixing `echo $base | sed -e "s|${SEARCHPATH}||g"`"
    chmod +t $base
    if [ -L ${todoname} ]; then
        echo Removing symlink "${todoname}"
        rm ${todoname}
    fi
    if [ -e ${todoname} ]; then
        echo "Error! Cannot move ${i} as destination exists!"
        continue
    fi
    mv "${foundname}" "${todoname}"
    ln -s "${todoname}" "${foundname}"
    chown vpopmail:vpopmail "${foundname}"
    chmod -t $base
done;
