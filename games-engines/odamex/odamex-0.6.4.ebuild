# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-engines/odamex/odamex-0.6.4.ebuild,v 1.4 2014/05/15 16:42:25 ulm Exp $

EAPI=5
WX_GTK_VER="2.8"
inherit cmake-utils eutils gnome2-utils wxwidgets games

MY_P=${PN}-src-${PV}
DESCRIPTION="An online multiplayer, free software engine for Doom and Doom II"
HOMEPAGE="http://odamex.net/"
SRC_URI="mirror://sourceforge/${PN}/Odamex/${PV}/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="dedicated +odalaunch master portmidi server"

RDEPEND="
	dedicated? ( >=net-libs/miniupnpc-1.8 )
	!dedicated? (
		>=media-libs/libsdl-1.2.9[X,sound,joystick,video]
		>=media-libs/sdl-mixer-1.2.6
		odalaunch? ( x11-libs/wxGTK:${WX_GTK_VER}[X] )
		portmidi? ( media-libs/portmidi )
		server? ( >=net-libs/miniupnpc-1.8 )
	)"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}"/1-${P}-install-rules.patch \
		"${FILESDIR}"/2-${P}-cmake-options.patch \
		"${FILESDIR}"/3-${P}-wad-search-path.patch \
		"${FILESDIR}"/4-${P}-odalauncher-bin-path.patch

	epatch_user
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_BINDIR="${GAMES_BINDIR}"
		-DCMAKE_INSTALL_DATADIR="${GAMES_DATADIR}"/${PN}
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
