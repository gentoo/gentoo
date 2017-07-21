# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils gnome2-utils xdg-utils

DESCRIPTION="A BBS client for Linux"
HOMEPAGE="https://github.com/qterm/qterm"
SRC_URI="https://github.com/qterm/qterm/archive/0.7.1.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="libressl"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtmultimedia:5
	dev-qt/qtnetwork:5
	dev-qt/qtprintsupport:5
	dev-qt/qtscript:5[scripttools]
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	x11-libs/libX11
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:= )
"
DEPEND="${RDEPEND}
	dev-qt/linguist-tools:5
	dev-qt/qthelp:5
	x11-proto/xproto
"

DOCS=( README.rst RELEASE_NOTES TODO )

src_prepare() {
	cmake-utils_src_prepare

	sed -i -e "s/Exec=qterm/Exec=QTerm/" src/${PN}.desktop || die
}

src_configure() {
	xdg_environment_reset

	local mycmakeargs=(
		-DQT5=ON
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	mv "${D}"/usr/bin/qterm "${D}"/usr/bin/QTerm || die
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
