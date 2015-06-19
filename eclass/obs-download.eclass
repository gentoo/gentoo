# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/obs-download.eclass,v 1.4 2012/10/02 10:57:52 scarabeus Exp $

# @ECLASS: obs-download.eclass
# @MAINTAINER:
# suse@gentoo.org
# @BLURB: Simplifies downloading from openSUSE Build Service.
# @DESCRIPTION:
# This eclass constructs OBS_URI based on provided project in openSUSE Build
# Service and package name. It can be used by packages/eclasses to download
# actual files.
#
# All you need to do in order to use it is set OBS_PROJECT and OBS_PACKAGE and
# inherit this eclass. It will provide OBS_URI in return which you will prepend
# to your files and use it in SRC_URI. Alternatively you can just set
# OPENSUSE_RELEASE and OBS_PACKAGE and it will give you back OBS_URI for
# downloading files from obs project corresponding to the specified openSUSE
# release.

# @ECLASS-VARIABLE: OPENSUSE_RELEASE
# @DEFAULT_UNSET
# @DESCRIPTION:
# From which openSUSE realease to take files.
# Eg.: 12.1, 12.2, Factory

# @ECLASS-VARIABLE: OBS_PROJECT
# @DEFAULT_UNSET
# @DESCRIPTION:
# In which obs project pakage is.
# This variable does not have to be set and is overriden, if
# OPENSUSE_RELEASE is provided.

# @ECLASS-VARIABLE: OBS_PACKAGE
# @DESCRIPTION:
# Name of the package we want to take files from.
# By default taken from ${PN}.

[[ -z ${OPENSUSE_RELEASE} ]] || OBS_PROJECT="openSUSE:${OPENSUSE_RELEASE}"
[[ -n ${OBS_PROJECT} ]]      || die "OBS_PROJECT not set!"
[[ -n ${OBS_PACKAGE} ]]      || OBS_PACKAGE="${PN}"

OBS_URI="https://api.opensuse.org/public/source/${OBS_PROJECT}/${OBS_PACKAGE}"
