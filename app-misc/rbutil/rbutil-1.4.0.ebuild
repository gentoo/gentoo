# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit desktop gnome2-utils qmake-utils

DESCRIPTION="Rockbox open source firmware manager for music players"
HOMEPAGE="https://www.rockbox.org/wiki/RockboxUtility"
SRC_URI="https://download.rockbox.org/${PN}/source/RockboxUtility-v${PV}-src.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug"

RDEPEND="dev-libs/quazip
	dev-qt/qtcore:5=
	dev-qt/qtgui:5=
	dev-qt/qtnetwork:5=
	dev-qt/qtwidgets:5=
	media-libs/speex
	media-libs/speexdsp
	virtual/libusb:1"

DEPEND="${RDEPEND}
	dev-qt/linguist-tools:5"

S="${WORKDIR}/RockboxUtility-v${PV}/${PN}/${PN}qt"

PATCHES=(
	"${FILESDIR}"/quazip.patch
)

src_prepare() {
	default
	rm -rv quazip/ zlib/ || die
}

src_configure() {
	# Generate binary translations.
	lrelease ${PN}qt.pro || die

	# noccache is required to call the correct compiler.
	eqmake5 CONFIG+="noccache $(use debug && echo dbg)"
}

src_install() {
	local icon size
	for icon in icons/rockbox-*.png; do
		size=${icon##*-}
		size=${size%%.*}
		newicon -s "${size}" "${icon}" rockbox.png
	done

	dobin RockboxUtility
	make_desktop_entry RockboxUtility "Rockbox Utility" rockbox
	dodoc changelog.txt
}

pkg_preinst() { gnome2_icon_savelist; }
pkg_postinst() { gnome2_icon_cache_update; }
pkg_postrm() { gnome2_icon_cache_update; }
