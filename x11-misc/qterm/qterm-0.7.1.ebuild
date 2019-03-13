# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit cmake-utils gnome2-utils xdg-utils

DESCRIPTION="A BBS client based on Qt"
HOMEPAGE="https://github.com/qterm/qterm"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="libressl"

RDEPEND="dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtmultimedia:5
	dev-qt/qtnetwork:5
	dev-qt/qtprintsupport:5
	dev-qt/qtscript:5[scripttools]
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	x11-libs/libX11
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:= )"
DEPEND="${RDEPEND}
	dev-qt/linguist-tools:5
	dev-qt/qthelp:5
	x11-base/xorg-proto"

PATCHES=(
	"${FILESDIR}"/${PN}-libressl.patch
	"${FILESDIR}"/${P}-headers.patch
)
DOCS=( README.rst RELEASE_NOTES TODO )

src_prepare() {
	# file collision with sys-cluster/torque, bug #176533
	sed -i "/PROGRAME /s/qterm/QTerm/" CMakeLists.txt
	sed -i "s/Exec=qterm/Exec=QTerm/" src/${PN}.desktop

	cmake-utils_src_prepare
	xdg_environment_reset
}

src_configure() {
	local mycmakeargs=(
		-DQT5=ON
	)
	cmake-utils_src_configure
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
