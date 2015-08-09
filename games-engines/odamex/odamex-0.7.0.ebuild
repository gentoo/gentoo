# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
WX_GTK_VER="3.0"
inherit cmake-utils eutils gnome2-utils wxwidgets games

MY_P=${PN}-src-${PV}
DESCRIPTION="An online multiplayer, free software engine for Doom and Doom II"
HOMEPAGE="http://odamex.net/"
SRC_URI="mirror://sourceforge/${PN}/Odamex/${PV}/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dedicated +odalaunch master portmidi server"

RDEPEND="
	dedicated? ( >=net-libs/miniupnpc-1.8 )
	!dedicated? (
		media-libs/libpng:0
		>=media-libs/libsdl-1.2.9[X,sound,joystick,video]
		>=media-libs/sdl-mixer-1.2.6
		odalaunch? ( x11-libs/wxGTK:${WX_GTK_VER}[X] )
		portmidi? ( media-libs/portmidi )
		server? ( >=net-libs/miniupnpc-1.8 )
	)"
DEPEND="${RDEPEND}"

S=${WORKDIR}/src-${PV:2:3}

pkg_pretend() {
	if ! test-flag-CXX -std=c++11; then
		die "You need at least GCC 4.7.x or Clang >= 3.0 for C++11-specific compiler flags"
	fi
}

src_prepare() {
	epatch "${FILESDIR}"/1-${P}-install-rules.patch \
		"${FILESDIR}"/2-${P}-cmake-options.patch \
		"${FILESDIR}"/3-${P}-wad-search-path.patch \
		"${FILESDIR}"/4-${P}-odalauncher-bin-path.patch \
		"${FILESDIR}"/${P}-miniupnpc.patch

	rm -r libraries/libminiupnpc || die

	epatch_user
}

src_configure() {
	local mycmakeargs=(
		-DUSE_INTREE_PORTMIDI=OFF
		-DCMAKE_INSTALL_BINDIR="${GAMES_BINDIR}"
		-DCMAKE_INSTALL_DATADIR="${GAMES_DATADIR}"
		$(cmake-utils_use_build master MASTER)
	)

	if use dedicated ; then
		mycmakeargs+=(
			-DBUILD_CLIENT=OFF
			-DBUILD_ODALAUNCH=OFF
			-DBUILD_SERVER=ON
			-DENABLE_PORTMIDI=OFF
		)
	else
		mycmakeargs+=(
			-DBUILD_CLIENT=ON
			$(cmake-utils_use_build odalaunch ODALAUNCH)
			$(cmake-utils_use_build server SERVER)
			$(cmake-utils_use_enable portmidi PORTMIDI)
		)
	fi

	append-cxxflags -std=c++11

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install

	if ! use dedicated ; then
		newicon -s 128 "${S}/media/icon_${PN}_128.png" "${PN}.png"
		make_desktop_entry ${PN}

		if use odalaunch ; then
			newicon -s 128 "${S}/media/icon_odalaunch_128.png" "odalaunch.png"
			make_desktop_entry odalaunch "Odamex Launcher" odalaunch
		fi
	fi

	prepgamesdirs
}

pkg_preinst() {
	games_pkg_preinst
	gnome2_icon_savelist
}

pkg_postinst() {
	games_pkg_postinst
	einfo
	elog "This is just the engine, you will need doom resource files in order to play."
	elog "Check: http://odamex.net/wiki/FAQ#What_data_files_are_required.3F"
	einfo
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
