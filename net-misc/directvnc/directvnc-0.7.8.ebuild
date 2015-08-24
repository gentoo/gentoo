# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_IN_SOURCE_BUILD=1
AUTOTOOLS_AUTORECONF=1

inherit eutils autotools-utils

DESCRIPTION="Very thin VNC client for unix framebuffer systems"
HOMEPAGE="https://drinkmilk.github.com/directvnc/"
SRC_URI="https://github.com/downloads/drinkmilk/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="+mouse dmalloc"

RDEPEND="dev-libs/DirectFB[fbcon,dynload]
	virtual/jpeg"

DEPEND="${RDEPEND}
	dmalloc? ( dev-libs/dmalloc )
	x11-proto/xproto"

DOCS=( NEWS THANKS )

src_prepare() {
	use mouse || epatch "${FILESDIR}"/${P}-mouse.patch

	# fix package version
	sed -i -e '/^AM_INIT_AUTOMAKE/s/0.7.7/0.7.8/g' configure.in || die
	# fix build system don't respect --docdir option
	sed -i -e 's|$(prefix)/share/doc/@PACKAGE@|@docdir@|g' Makefile.am || die

	autotools-utils_src_prepare
}

src_configure() {
	myeconfargs=(
		$(use_with dmalloc)
	)

	autotools-utils_src_configure
}

pkg_postinst() {
	einfo "To customize your keyboard mapping, please consult the manual"
	einfo " commmand: man 7 directvnc-kbmapping"
}
