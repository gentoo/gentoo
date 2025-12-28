# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

WX_GTK_VER="3.2-gtk3"
inherit cmake desktop prefix wxwidgets xdg

DESCRIPTION="Online multiplayer free software engine for DOOM"
HOMEPAGE="https://odamex.net/"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/${PV}/${PN}-src-${PV}.tar.xz"
S="${WORKDIR}/${PN}-src-${PV}"
LICENSE="GPL-2+ MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="+client master +odalaunch portmidi server upnp"
REQUIRED_USE="|| ( client master server )"

# protobuf is still bundled. Unfortunately an old version is required for C++98
# compatibility. We could use C++11, but upstream is concerned about using a
# completely different protobuf version on a multiplayer-focused engine.

RDEPEND="
	client? (
		dev-cpp/cpptrace
		dev-libs/jsoncpp:=
		media-libs/libpng:0=
		media-libs/libsdl2[joystick,sound,video]
		media-libs/sdl2-mixer
		net-misc/curl
		>=x11-libs/fltk-1.4.3-r1:1=
		x11-libs/libX11
		portmidi? ( media-libs/portmidi )
	)
	odalaunch? (
		x11-libs/wxGTK:${WX_GTK_VER}=
	)
	server? (
		dev-libs/jsoncpp:=
		virtual/zlib:=
		upnp? ( net-libs/miniupnpc:= )
	)
"
DEPEND="${RDEPEND}"
BDEPEND="games-util/deutex"

src_prepare() {
	# All this is unneeded and includes old CMake declarations.
	rm -r libraries/{cpptrace,curl,fltk,jsoncpp,libadlmidi/android,libpng,miniupnp,portmidi,protobuf/{examples,third_party},zlib}/ || die

	cmake_src_prepare
	hprefixify common/d_main.cpp
}

src_configure() {
	use odalaunch && setup-wxwidgets

	local mycmakeargs=(
		-DUSE_INTERNAL_CPPTRACE=0
		-DUSE_INTERNAL_FLTK=0
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

	cmake_src_configure
}

src_install() {
	if use client ; then
		for size in 96 128 256 512; do
			newicon -s ${size} "${S}/media/icon_${PN}_${size}.png" "${PN}.png"
		done
		make_desktop_entry "${PN}" "Odamex"

		if use odalaunch ; then
			for size in 96 128 256 512; do
				newicon -s ${size} "${S}/media/icon_odalaunch_${size}.png" "odalaunch.png"
			done
			make_desktop_entry odalaunch "Odamex Launcher" odalaunch
		fi
	fi

	cmake_src_install
}
