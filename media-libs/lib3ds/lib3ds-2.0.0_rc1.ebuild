# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/lib3ds/lib3ds-2.0.0_rc1.ebuild,v 1.8 2015/01/22 08:35:00 mr_bones_ Exp $

EAPI=5
inherit eutils

MY_PV="20080909"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="library for managing 3D-Studio Release 3 and 4 .3DS files"
HOMEPAGE="http://code.google.com/p/lib3ds/"
SRC_URI="http://lib3ds.googlecode.com/files/${MY_P}.zip"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE=""

S=${WORKDIR}/${MY_P}

RDEPEND="media-libs/freeglut
	virtual/opengl"
DEPEND="${RDEPEND}
	app-arch/unzip"

src_prepare() {
#	epatch "${FILESDIR}"/${P}-underlinking.patch
	epatch "${FILESDIR}"/${P}-underlinking-no-autoreconf.patch
}
