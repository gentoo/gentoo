# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

COMMIT=33ed278b9b543554fd6a556fd391eb4c78faab07
MY_PN=qtscrob
MY_P=${MY_PN}-${PV}
inherit desktop gnome2-utils qmake-utils toolchain-funcs

DESCRIPTION="Updates last.fm profiles using information from supported portable music players"
HOMEPAGE="http://qtscrob.sourceforge.net/"
SRC_URI="https://sourceforge.net/code-snapshots/git/q/qt/${MY_PN}/code.git/${MY_PN}-code-${COMMIT}.zip -> ${P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtsql:5
	dev-qt/qtwidgets:5
	media-libs/libmtp:=
	net-misc/curl"
DEPEND="${RDEPEND}
	dev-qt/linguist-tools:5
	virtual/pkgconfig"

S="${WORKDIR}/${MY_PN}-code-${COMMIT}"

PATCHES=(
	"${FILESDIR}"/${P}-qt5.patch
	"${FILESDIR}"/${P}-qt5.11.patch
)

src_configure() {
	pushd src >/dev/null
	eqmake5 ${MY_PN}.pro
	popd >/dev/null
}

src_compile() {
	emake -C src
}

src_install() {
	newbin src/cli/scrobbler qtscrobbler-cli

	newbin src/qt/qtscrob qtscrobbler
	newicon src/qt/resources/icons/256x256/qtscrob.png qtscrobbler.png
	make_desktop_entry qtscrobbler QtScrobbler

	einstalldocs
}

pkg_postinst() { gnome2_icon_cache_update; }
pkg_postrm() { gnome2_icon_cache_update; }
