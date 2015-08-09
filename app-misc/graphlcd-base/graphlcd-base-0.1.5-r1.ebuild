# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils flag-o-matic multilib

VERSION="226" # every bump, new version

DESCRIPTION="Graphical LCD Driver"
HOMEPAGE="http://projects.vdr-developer.org/projects/graphlcd"
SRC_URI="mirror://vdr-developerorg/${VERSION}/${P}.tgz
		mirror://vdrfiles/${PN}/${P}_utf8.diff.tgz"

KEYWORDS="amd64 x86 ~ppc"
SLOT="0"
LICENSE="GPL-2"
IUSE="truetype unicode g15"

DEPEND=""

RDEPEND="truetype? ( media-libs/freetype media-fonts/corefonts )
		unicode? ( media-libs/freetype media-fonts/corefonts )
		g15? ( app-misc/g15daemon )"

src_unpack() {

	unpack ${A}
	cd "${S}"

	sed -i Make.config -e "s:usr\/local:usr:" -e "s:FLAGS *=:FLAGS ?=:"
	epatch "${FILESDIR}/${P}-nostrip.patch"
	epatch "${FILESDIR}/${P}-gcc43.patch"

	use !truetype && sed -i "s:HAVE_FREETYPE2:#HAVE_FREETYPE2:" Make.config

	use unicode && epatch "${WORKDIR}/${P}_utf8.diff" && \
	sed -i "s:#HAVE_FREETYPE2:HAVE_FREETYPE2:" Make.config
}

src_install() {

	make DESTDIR="${D}"/usr LIBDIR="${D}"/usr/$(get_libdir) install || die "make install failed"

	insinto /etc
	doins graphlcd.conf

	dodoc docs/*
}
