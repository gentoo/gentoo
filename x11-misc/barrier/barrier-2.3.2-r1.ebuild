# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop xdg cmake

DESCRIPTION="Share a mouse and keyboard between computers (fork of Synergy)"
HOMEPAGE="https://github.com/debauchee/barrier"
SRC_URI="https://github.com/debauchee/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="gui libressl"

RDEPEND="
	net-misc/curl
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXi
	x11-libs/libXinerama
	x11-libs/libXrandr
	x11-libs/libXtst
	gui? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtnetwork:5
		dev-qt/qtwidgets:5
		net-dns/avahi[mdnsresponder-compat]
	)
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
"

PATCHES=(
	"${FILESDIR}"/${P}-inf-loop.patch
	"${FILESDIR}"/${P}-no-avahi.patch
	"${FILESDIR}"/${P}-pthread.patch
	"${FILESDIR}"/${P}-qt-gui-only.patch
)

DOCS=(
	ChangeLog
	README.md
	doc/${PN}.conf.example{,-advanced,-basic}
)

src_configure() {
	local mycmakeargs=(
		-DBARRIER_BUILD_GUI=$(usex gui)
		-DBARRIER_BUILD_INSTALLER=OFF
		-DBARRIER_REVISION=00000000
		-DBARRIER_VERSION_STAGE=gentoo
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install
	einstalldocs
	doman doc/${PN}{c,s}.1

	if use gui; then
		doicon -s scalable res/${PN}.svg
		doicon -s 256 res/${PN}.png
		make_desktop_entry ${PN} Barrier ${PN} Utility
	fi
}
