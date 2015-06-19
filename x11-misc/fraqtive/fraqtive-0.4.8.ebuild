# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/fraqtive/fraqtive-0.4.8.ebuild,v 1.1 2015/02/05 09:38:29 jer Exp $

EAPI=5
inherit eutils gnome2-utils qmake-utils toolchain-funcs

DESCRIPTION="an open source, multi-platform generator of the Mandelbrot family fractals"
HOMEPAGE="http://fraqtive.mimec.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="qt5 cpu_flags_x86_sse2"

RDEPEND="
	!qt5? (
		dev-qt/qtcore:4
		dev-qt/qtgui:4
		dev-qt/qtopengl:4
	)
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtopengl:5
	)
	virtual/glu
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

src_configure() {
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

	if use qt5; then
		eqmake5
	else
		eqmake4
	fi
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
