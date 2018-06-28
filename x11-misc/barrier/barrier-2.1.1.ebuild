# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils cmake-utils flag-o-matic

DESCRIPTION="Lets you easily share a single mouse and keyboard between multiple computers"
HOMEPAGE="https://github.com/debauchee/barrier"
SRC_URI="
	https://github.com/debauchee/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="libressl qt5"
RESTRICT="test"

DEPEND="
	!libressl? ( dev-libs/openssl:* )
	libressl? ( dev-libs/libressl )
	net-misc/curl
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXi
	x11-libs/libXinerama
	x11-libs/libXrandr
	x11-libs/libXtst
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
		net-dns/avahi[mdnsresponder-compat]
	)
	x11-base/xorg-proto
"

RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DBARRIER_BUILD_INSTALLER=OFF
		-DBARRIER_BUILD_GUI=$(usex qt5)
	)
	cmake-utils_src_configure
}

src_install() {
	if use qt5; then
		newicon -s 256 res/${PN}.png ${PN}.png
		newmenu res/${PN}.desktop ${PN}.desktop
	fi
}
