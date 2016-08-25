# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# @ECLASS: kde5-meta-pkg.eclass
# @MAINTAINER:
# kde@gentoo.org
# @BLURB: This eclass contains boilerplate for KDE 5 meta packages
# @DESCRIPTION:
# This eclass should only be used for defining meta packages for KDE 5.

if [[ -z ${_KDE5_META_PKG_ECLASS} ]]; then
_KDE5_META_PKG_ECLASS=1

inherit kde5-functions

HOMEPAGE="https://www.kde.org/"
LICENSE="metapackage"
SLOT="5"

if [[ ${KDE_BLOCK_SLOT4} = true && ${CATEGORY} = kde-apps ]]; then
	RDEPEND+=" !kde-apps/${PN}:4"
fi

fi
