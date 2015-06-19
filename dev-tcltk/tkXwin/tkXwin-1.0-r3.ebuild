# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tcltk/tkXwin/tkXwin-1.0-r3.ebuild,v 1.5 2012/10/21 17:06:50 armin76 Exp $

EAPI=4

inherit autotools-utils multilib toolchain-funcs

DESCRIPTION="Tcl/Tk library to detect idle periods of an X session"
HOMEPAGE="http://beepcore-tcl.sourceforge.net/"
SRC_URI="http://beepcore-tcl.sourceforge.net/${P}.tgz"

LICENSE="BSD"
SLOT="0"
IUSE="debug static-libs threads"
KEYWORDS="amd64 ppc x86"

DEPEND="
	dev-lang/tk[threads?]
	x11-libs/libXScrnSaver
	x11-libs/libX11
	x11-libs/libXext
	x11-proto/scrnsaverproto
	x11-proto/xextproto"
RDEPEND="${DEPEND}"

PATCHES=(
		"${FILESDIR}"/${PV}-Makefile.in.diff
		"${FILESDIR}"/${P}-configure.patch
	)

AUTOTOOLS_IN_SOURCE_BUILD=1

src_prepare() {
	tc-export CC AR RANLIB
	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		--with-tcl="${EPREFIX}/usr/$(get_libdir)"
		--with-tk="${EPREFIX}/usr/$(get_libdir)"
		--enable-gcc
		--with-x
		$(use_enable threads)
		$(use_enable debug symbols)
	)
	autotools-utils_src_configure
}
