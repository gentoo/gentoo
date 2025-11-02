# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-1 )

inherit cmake lua-single vala xdg

DESCRIPTION="Client for the nethack-style but more in the line of UO"
HOMEPAGE="https://crossfire.real-time.com/"
SRC_URI="https://downloads.sourceforge.net/project/crossfire/${PN}/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="lua"
REQUIRED_USE="lua? ( ${LUA_REQUIRED_USE} )"

RDEPEND="
	dev-libs/glib:2
	media-libs/libpng:=
	media-libs/libsdl2
	media-libs/sdl2-mixer[vorbis,wav]
	net-misc/curl
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:2
	x11-libs/pango
	lua? ( ${LUA_DEPS} )
"
DEPEND="${RDEPEND}"
BDEPEND="
	$(vala_depend)
	dev-lang/perl
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${P}-sdl.patch
	"${FILESDIR}"/${P}-staticlib.patch
	"${FILESDIR}"/${P}-fix_overflow.patch
	"${FILESDIR}"/${P}-cmake4.patch
)

pkg_setup() {
	use lua && lua-single_pkg_setup
	vala_setup
}

src_configure() {
	local mycmakeargs=(
		-DLUA=$(usex lua)
		-DMETASERVER2=ON
		# libsdl2 and sdl2-mixer are required anyway
		-DSOUND=ON
		-DVALA_EXECUTABLE="${VALAC}"
	)

	cmake_src_configure
}
