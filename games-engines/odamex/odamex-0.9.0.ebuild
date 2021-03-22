# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

WX_GTK_VER="3.0-gtk3"
inherit cmake desktop prefix wxwidgets xdg

DESCRIPTION="Online multiplayer free software engine for DOOM"
HOMEPAGE="https://odamex.net/"
SRC_URI="mirror://sourceforge/${PN}/Odamex/${PV}/${PN}-src-${PV}.tar.bz2 -> ${P}.tar.bz2"

LICENSE="GPL-2+ MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="+client master +odalaunch portmidi server upnp X"
REQUIRED_USE="|| ( client master server )"

RDEPEND="
	client? (
		media-libs/libpng:0=
		media-libs/libsdl2[joystick,sound,video]
		media-libs/sdl2-mixer
		odalaunch? ( x11-libs/wxGTK:${WX_GTK_VER}[X] )
		portmidi? ( media-libs/portmidi )
		X? ( x11-libs/libX11 )
	)
	server? (
		dev-libs/jsoncpp:=
		upnp? ( net-libs/miniupnpc:= )
	)"
DEPEND="${RDEPEND}"
BDEPEND="games-util/deutex"

S="${WORKDIR}/${PN}-src-${PV}"

PATCHES=(
	"${FILESDIR}/${P}-Unbundle-miniupnpc.patch"
	"${FILESDIR}/${P}-Set-IMPORTED_LOCATION-for-jsoncpp.patch"
)

src_prepare() {
	rm -r libraries/libminiupnpc || die
	hprefixify common/d_main.cpp

	use odalaunch && setup-wxwidgets

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_X11=$(usex !X)
		-DUSE_INTERNAL_LIBS=0
		-DBUILD_CLIENT=$(usex client)
		-DBUILD_LAUNCHER=$(usex odalaunch)
		-DBUILD_MASTER=$(usex master)
		-DBUILD_SERVER=$(usex server)
		-DBUILD_OR_FAIL=1
		-DENABLE_PORTMIDI=$(usex portmidi)
		-DUSE_MINIUPNP=$(usex upnp)
	)

	cmake_src_configure
}

src_install() {
	if use client ; then
		newicon -s 128 "${S}/media/icon_${PN}_128.png" "${PN}.png"
		make_desktop_entry "${PN}" "Odamex"

		if use odalaunch ; then
			newicon -s 128 "${S}/media/icon_odalaunch_128.png" "odalaunch.png"
			make_desktop_entry odalaunch "Odamex Launcher" odalaunch
		fi
	fi

	cmake_src_install
}
