# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-util/glbsp/glbsp-2.24.ebuild,v 1.6 2015/03/24 17:24:31 ago Exp $

EAPI=5
inherit eutils toolchain-funcs versionator

MY_PV=$(delete_version_separator 1)
DESCRIPTION="A node builder specially designed for OpenGL ports of the DOOM game engine"
HOMEPAGE="http://glbsp.sourceforge.net/"
SRC_URI="mirror://sourceforge/glbsp/${PN}_src_${MY_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="fltk"

DEPEND="fltk? ( x11-libs/fltk:1 )"
RDEPEND=${DEPEND}

S=${WORKDIR}/${P}-source

src_prepare() {
	epatch "${FILESDIR}"/${P}-ldflags.patch
	sed -i \
		-e "/^CC=/s:=.*:=$(tc-getCC):" \
		-e "/^CXX=/s:=.*:=$(tc-getCXX):" \
		-e "/^AR=/s:ar:$(tc-getAR):" \
		-e "/^RANLIB=/s:=.*:=$(tc-getRANLIB):" \
		-e "s:-O2:${CFLAGS}:" \
		-e "s:-O -g3:${CFLAGS}:" \
		Makefile.unx \
		nodeview/Makefile.unx || die
}

src_compile() {
	emake -f Makefile.unx
	if use fltk ; then
		emake -f Makefile.unx glBSPX \
			FLTK_FLAGS="$(fltk-config --cflags)" \
			FLTK_LIBS="$(fltk-config --use-images --ldflags)"
		emake -f Makefile.unx -C nodeview \
			FLTK_CFLAGS="$(fltk-config --cflags)" \
			FLTK_LIBS="$(fltk-config --use-images --ldflags)"
	fi
}

src_install() {
	dobin glbsp
	dolib.a libglbsp.a
	doman glbsp.1
	dodoc AUTHORS.txt glbsp.txt
	insinto "/usr/include"
	doins "src/glbsp.h"

	if use fltk ; then
		newbin glBSPX glbspx
		newicon gui/icon.xpm glbspx.xpm
		make_desktop_entry glbspx glBSPX glbspx

		dobin nodeview/nodeview
		docinto nodeview
		dodoc nodeview/{README,TODO}.txt
	fi
}
