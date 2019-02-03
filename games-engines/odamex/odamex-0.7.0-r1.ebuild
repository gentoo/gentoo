# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

WX_GTK_VER="3.0"
inherit cmake-utils desktop gnome2-utils readme.gentoo-r1 wxwidgets

MY_P=${PN}-src-${PV}
DESCRIPTION="Online multiplayer, free software engine for Doom and Doom II"
HOMEPAGE="https://odamex.net/"
SRC_URI="mirror://sourceforge/${PN}/Odamex/${PV}/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dedicated master +odalaunch portmidi server"

RDEPEND="
	dedicated? ( >=net-libs/miniupnpc-1.8:0= )
	!dedicated? (
		media-libs/libpng:0=
		>=media-libs/libsdl-1.2.9[X,sound,joystick,video]
		>=media-libs/sdl-mixer-1.2.6
		odalaunch? ( x11-libs/wxGTK:${WX_GTK_VER}[X] )
		portmidi? ( media-libs/portmidi )
		server? ( >=net-libs/miniupnpc-1.8:0= )
	)
"
DEPEND="${RDEPEND}"

DOC_CONTENTS="
	This is just the engine, you will need doom resource files in order to play.
	Check: http://odamex.net/wiki/FAQ#What_data_files_are_required.3F
"

S="${WORKDIR}/src-${PV:2:3}"

PATCHES=(
	"${FILESDIR}"/1-${P}-install-rules.patch
	"${FILESDIR}"/2-${P}-cmake-options.patch
	"${FILESDIR}"/3-${P}-wad-search-path.patch
	"${FILESDIR}"/4-${P}-odalauncher-bin-path.patch
	"${FILESDIR}"/${P}-miniupnpc.patch
	"${FILESDIR}"/${P}-miniupnpc20.patch
	"${FILESDIR}"/${P}-gcc6.patch
)

src_prepare() {
	cmake-utils_src_prepare
	rm -r libraries/libminiupnpc || die
}

src_configure() {
	local mycmakeargs=(
		-DUSE_INTREE_PORTMIDI=OFF
		-DCMAKE_INSTALL_BINDIR="/usr/bin"
		-DCMAKE_INSTALL_DATADIR="/usr/share"
		-DBUILD_MASTER=$(usex master)
	)

	if use dedicated ; then
		mycmakeargs+=(
			-DBUILD_CLIENT=OFF
			-DBUILD_ODALAUNCH=OFF
			-DENABLE_PORTMIDI=OFF
			-DBUILD_SERVER=ON
		)
	else
		mycmakeargs+=(
			-DBUILD_CLIENT=ON
			-DBUILD_ODALAUNCH=$(usex odalaunch)
			-DENABLE_PORTMIDI=$(usex portmidi)
			-DBUILD_SERVER=$(usex server)
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
	readme.gentoo_create_doc

	if ! use dedicated ; then
		newicon -s 128 "${S}/media/icon_${PN}_128.png" "${PN}.png"
		make_desktop_entry ${PN}

		if use odalaunch ; then
			newicon -s 128 "${S}/media/icon_odalaunch_128.png" "odalaunch.png"
			make_desktop_entry odalaunch "Odamex Launcher" odalaunch
		fi
	fi
}

pkg_postinst() {
	gnome2_icon_cache_update
	readme.gentoo_print_elog
}

pkg_postrm() {
	gnome2_icon_cache_update
}
