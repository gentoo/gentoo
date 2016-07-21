# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit eutils gnome2-utils qt4-r2 toolchain-funcs

MY_PN=qtscrob
MY_P=${MY_PN}-${PV}

DESCRIPTION="Updates a last.fm profile using information from a supported portable music player"
HOMEPAGE="http://qtscrob.sourceforge.net/"
SRC_URI="mirror://sourceforge/${MY_PN}/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="cli +qt4"

RDEPEND=">=media-libs/libmtp-1.1.0
	net-misc/curl
	dev-qt/qtgui:4"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-Makefile.patch \
		"${FILESDIR}"/${P}-free.patch
}

src_configure() {
	if use qt4; then
		pushd src/qt >/dev/null
		eqmake4 ${MY_PN}.pro
		popd >/dev/null
	fi
}

src_compile() {
	if use cli; then
		tc-export CXX
		emake -C src/cli
	fi

	if use qt4; then
		emake -C src/qt
	fi
}

src_install() {
	if use cli; then
		newbin src/cli/scrobble-cli qtscrobbler-cli
	fi

	if use qt4; then
		pushd src/qt >/dev/null
		newbin qtscrob qtscrobbler
		insinto /usr/share/icons/hicolor/128x128/apps
		newins resources/icons/128.png qtscrobbler.png
		make_desktop_entry qtscrobbler QtScrobbler
		popd >/dev/null
	fi

	dodoc AUTHORS CHANGELOG README
}

pkg_preinst() {	gnome2_icon_savelist; }
pkg_postinst() { gnome2_icon_cache_update; }
pkg_postrm() { gnome2_icon_cache_update; }
