# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# @ECLASS: kde4-meta-pkg.eclass
# @MAINTAINER:
# kde@gentoo.org
# @BLURB: This eclass contains boilerplate for kde 4.X meta packages
# @DESCRIPTION:
# This eclass should only be used for defining meta packages for KDE4.

if [[ -z ${_KDE4_META_PKG_ECLASS} ]]; then
_KDE4_META_PKG_ECLASS=1

inherit kde4-functions

HOMEPAGE="https://www.kde.org/"

LICENSE="metapackage"
IUSE="aqua"

SLOT=4

fi
