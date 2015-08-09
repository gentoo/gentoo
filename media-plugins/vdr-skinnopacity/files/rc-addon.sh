#!/bin/sh
# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

plugin_pre_vdr_start() {
	if [ -n "${SKINNOPACITY_EPGIMAGESPATH}" ]; then
		add_plugin_param "-e ${SKINNOPACITY_EPGIMAGESPATH}"
	fi

	if [ -n "${SKINNOPACITY_ICONSPATH}" ]; then
		add_plugin_param "-i ${SKINNOPACITY_ICONSPATH}"
	fi

	if [ -n "${SKINNOPACITY_LOGOPATH}" ]; then
		add_plugin_param "-l ${SKINNOPACITY_LOGOPATH}"
	fi
}
