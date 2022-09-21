# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

WX_GTK_VER="3.0-gtk3"
inherit cmake desktop prefix wxwidgets xdg

DESCRIPTION="Online multiplayer free software engine for DOOM"
HOMEPAGE="https://odamex.net/"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/${PV}/${PN}-src-${PV}.tar.xz"

LICENSE="GPL-2+ MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="+client hidpi master +odalaunch portmidi server upnp X"
REQUIRED_USE="|| ( client master server )"

# protobuf is still bundled. Unfortunately an old version is required for C++98
# compatibility. We could use C++11, but upstream is concerned about using a
# completely different protobuf version on a multiplayer-focused engine.

RDEPEND="
	client? (
		media-libs/libpng:0=
		media-libs/libsdl2[joystick,sound,video]
		media-libs/sdl2-mixer
		net-misc/curl
		!hidpi? ( x11-libs/fltk:1 )
		portmidi? ( media-libs/portmidi )
		X? ( x11-libs/libX11 )
	)
	odalaunch? ( x11-libs/wxGTK:${WX_GTK_VER}[X] )
	server? (
		dev-libs/jsoncpp:=
		upnp? ( net-libs/miniupnpc:= )
	)"
DEPEND="${RDEPEND}"
BDEPEND="games-util/deutex"

S="${WORKDIR}/${PN}-src-${PV}"

PATCHES=(
	"${FILESDIR}"/${PN}-10.0.0-unbundle-miniupnpc.patch
	"${FILESDIR}"/${PN}-10.0.0-unbundle-jsoncpp.patch
	"${FILESDIR}"/${PN}-10.0.0-unbundle-fltk.patch
	"${FILESDIR}"/${PN}-10.0.0-musl.patch
	"${FILESDIR}"/${PN}-10.0.0-master-std.patch
	"${FILESDIR}"/${PN}-10.0.0-gcc12.patch
)

src_prepare() {
	rm -r libraries/libminiupnpc || die
	hprefixify common/d_main.cpp

	use odalaunch && setup-wxwidgets

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DUSE_INTERNAL_FLTK=$(usex hidpi)
		-DUSE_INTERNAL_JSONCPP=0
		-DUSE_INTERNAL_LIBS=0
		-DUSE_INTERNAL_MINIUPNP=0
		-DBUILD_CLIENT=$(usex client)
		-DBUILD_LAUNCHER=$(usex odalaunch)
		-DBUILD_MASTER=$(usex master)
		-DBUILD_SERVER=$(usex server)
		-DBUILD_OR_FAIL=1
		-DENABLE_PORTMIDI=$(usex portmidi)
		-DUSE_MINIUPNP=$(usex upnp)
	)
	use client && mycmakeargs+=(-DCMAKE_DISABLE_FIND_PACKAGE_X11=$(usex !X))

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
