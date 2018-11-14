# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils gnome2-utils qmake-utils toolchain-funcs

DESCRIPTION="an open source, multi-platform generator of the Mandelbrot family fractals"
HOMEPAGE="https://fraqtive.mimec.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cpu_flags_x86_sse2"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtopengl:5
	virtual/glu
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

src_configure() {
	epatch "${FILESDIR}/${P}-qt-includes.patch"

	tc-export PKG_CONFIG
	sed -i -e "s|-lGLU|$( ${PKG_CONFIG} --libs glu )|g" src/src.pro || die
	local conf="release"

	if use cpu_flags_x86_sse2; then
		conf="$conf sse2"
	else
		conf="$conf no-sse2"
	fi

	echo "CONFIG += $conf" > "${S}"/config.pri
	echo "PREFIX = ${EPREFIX}/usr" >> "${S}"/config.pri
	# Don't strip wrt #252096
	echo "QMAKE_STRIP =" >> "${S}"/config.pri

	eqmake5
}

src_install() {
	emake INSTALL_ROOT="${D}" install
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
