# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils desktop desktop

DESCRIPTION="Eliminate the barrier between your machines"
HOMEPAGE="https://github.com/debauchee/barrier"
SRC_URI="
	https://github.com/debauchee/${PN}/releases/download/v${PV}/deterministic-${PN}-source.tar.gz -> ${P}.tar.gz
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="libressl qt5"
RESTRICT="test"

S="${WORKDIR}/${PN}"

COMMON_DEPEND="
	!libressl? ( dev-libs/openssl:= )
	libressl? ( dev-libs/libressl:= )
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
		dev-qt/qtnetwork:5
		dev-qt/qtwidgets:5
		net-dns/avahi[mdnsresponder-compat]
	)
"
DEPEND="
	${COMMON_DEPEND}
	x11-base/xorg-proto
"
RDEPEND="
	${COMMON_DEPEND}
"

DOCS=( doc/${PN}.conf.example{,-advanced,-basic} )

src_configure() {
	local mycmakeargs=(
		-DBARRIER_BUILD_GUI=$(usex qt5)
		-DBARRIER_BUILD_INSTALLER=OFF
	)

	cmake-utils_src_configure
}

src_install () {
	cmake-utils_src_install

	if use qt5 ; then
		insinto /usr/share/applications
		doins res/${PN}.desktop

		doicon -s scalable res/${PN}.svg
	fi

	insinto /etc
	newins doc/${PN}.conf.example ${PN}.conf

	doman doc/${PN}{c,s}.1
#	doman doc/${PN}s.1

	einstalldocs
}

pkg_postinst() {
	if use qt5 ; then
		xdg_desktop_database_update
		xdg_icon_cache_update
	fi
}

pkg_postrm() {
	if use qt5 ; then
		xdg_desktop_database_update
		xdg_icon_cache_update
	fi
}
