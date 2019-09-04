# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

WX_GTK_VER="3.0"
inherit cmake-utils desktop wxwidgets xdg

DESCRIPTION="Online multiplayer, free software engine for Doom and Doom II"
HOMEPAGE="https://odamex.net/"
SRC_URI="mirror://sourceforge/${PN}/Odamex/${PV}/${PN}-src-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+client master upnp +odalaunch portmidi server"
REQUIRED_USE="
	|| ( client master server )
	portmidi? ( client )
	upnp? ( server )"

RDEPEND="
	client? (
		media-libs/libpng:0=
		media-libs/libsdl2[X]
		media-libs/sdl2-mixer
		odalaunch? ( x11-libs/wxGTK:${WX_GTK_VER}[X] )
		portmidi? ( media-libs/portmidi )
	)
	server? (
		upnp? ( net-libs/miniupnpc:= )
	)"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}-src-${PV}"

PATCHES=(
	"${FILESDIR}"/${P}-miniupnpc.patch
)

src_prepare() {
	rm -r libraries/libminiupnpc || die
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_CLIENT=$(usex client)
		-DBUILD_MASTER=$(usex master)
		-DBUILD_ODALAUNCH=$(usex odalaunch)
		-DBUILD_SERVER=$(usex server)
		-DENABLE_PORTMIDI=$(usex portmidi)
		-DUSE_MINIUPNP=$(usex upnp)
	)

	cmake-utils_src_configure
}

src_install() {
	if use client ; then
		newicon -s 128 "${S}/media/icon_${PN}_128.png" "${PN}.png"
		make_desktop_entry ${PN}

		if use odalaunch ; then
			newicon -s 128 "${S}/media/icon_odalaunch_128.png" "odalaunch.png"
			make_desktop_entry odalaunch "Odamex Launcher" odalaunch
		fi
	fi

	cmake-utils_src_install
}
