#!/bin/sh
# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-tvguide/files/rc-addon.sh,v 1.2 2014/02/01 19:39:34 idl0r Exp $

plugin_pre_vdr_start() {
	if [ -n "${TVGUIDE_EPGIMAGESPATH}" ]; then
		add_plugin_param "-e ${TVGUIDE_EPGIMAGESPATH}"
	fi

	if [ -n "${TVGUIDE_ICONSPATH}" ]; then
		add_plugin_param "-i ${TVGUIDE_ICONSPATH}"
	fi

	if [ -n "${TVGUIDE_LOGOPATH}" ]; then
		add_plugin_param "-l ${TVGUIDE_LOGOPATH}"
	fi
}
