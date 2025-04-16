# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-3 )
PYTHON_COMPAT=( python3_{10..13} )
inherit autotools lua-single python-any-r1 xdg

DESCRIPTION="Modification of the classical Freedroid engine into an RPG"
HOMEPAGE="https://www.freedroid.org/"
SRC_URI="https://ftp.osuosl.org/pub/freedroid/freedroidRPG-${PV}/freedroidRPG-${PV}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="debug devtools opengl profile +sound"
REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND="
	${LUA_DEPS}
	media-libs/libpng:=
	media-libs/libsdl[opengl?,sound?,video]
	media-libs/sdl-gfx:=
	media-libs/sdl-image[jpeg,png]
	sys-libs/zlib:=
	virtual/libintl
	devtools? ( media-libs/sdl-ttf )
	opengl? (
		media-libs/glew:0=
		media-libs/libglvnd[X]
	)
	sound? ( media-libs/sdl-mixer[vorbis] )
"
DEPEND="${RDEPEND}"
BDEPEND="
	${PYTHON_DEPS}
	sys-devel/gettext
	app-alternatives/awk
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.0-AC_INCLUDES_DEFAULT.patch
)

pkg_setup() {
	lua-single_pkg_setup
	python-any-r1_pkg_setup
}

src_prepare() {
	default

	eautoreconf

	python_fix_shebang src/gen_savestruct.py
	rm data/sound/speak.py || die # unused, skip install + python rdep
}

src_configure() {
	local econfargs=(
		$(use_enable debug backtrace)
		$(use_enable debug)
		$(use_enable devtools dev-tools)
		$(use_enable opengl)
		$(use_enable profile rtprof)
		$(use_enable sound)
		$(use_with debug extra-warnings)
	)

	econf "${econfargs[@]}"
}
