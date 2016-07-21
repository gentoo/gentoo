# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=1
inherit autotools-multilib

DESCRIPTION="CAPI library used by AVM products"
HOMEPAGE="http://www.tabos.org/ffgtk"
SRC_URI="http://www.tabos.org/ffgtk/download/libcapi20-${PV}.tar.bz2"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/capi20"

RDEPEND="!net-dialup/capi4k-utils"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}/${P}-remove-libcapi20dyn.patch" )
