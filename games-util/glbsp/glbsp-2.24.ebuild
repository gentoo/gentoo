# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop toolchain-funcs

MY_PV=$(ver_rs 1 '')
DESCRIPTION="A node builder specially designed for OpenGL ports of the DOOM game engine"
HOMEPAGE="http://glbsp.sourceforge.net/"
SRC_URI="mirror://sourceforge/glbsp/${PN}_src_${MY_PV}.tar.gz"
S="${WORKDIR}"/${P}-source

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="fltk"

DEPEND="fltk? ( x11-libs/fltk:1 )"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-ldflags.patch
	"${FILESDIR}"/${P}-return-type.patch
)

src_prepare() {
	default

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
