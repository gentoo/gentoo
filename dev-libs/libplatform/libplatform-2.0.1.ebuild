# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils

MY_PN="platform"
MY_PN_PREFIX="p8"

DESCRIPTION="Platform support library used by libCEC and binary add-ons for Kodi"
HOMEPAGE="https://github.com/Pulse-Eight/platform"
SRC_URI="https://github.com/Pulse-Eight/${MY_PN}/archive/${MY_PN_PREFIX}-${MY_PN}-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

PATCHES=( "${FILESDIR}/${P}-arch-specific-libdirs.patch" )

S="${WORKDIR}/${MY_PN}-${MY_PN_PREFIX}-${MY_PN}-${PV}"
