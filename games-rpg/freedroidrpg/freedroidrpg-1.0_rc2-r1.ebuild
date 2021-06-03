# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-3 )
PYTHON_COMPAT=( python3_{8..10} )

inherit lua-single python-any-r1 xdg

MY_PV=$(ver_rs 2 '')

DESCRIPTION="Modification of the classical Freedroid engine into an RPG"
HOMEPAGE="https://www.freedroid.org"
SRC_URI="ftp://ftp.osuosl.org/pub/freedroid/freedroidRPG-$(ver_cut 1-2)/freedroidRPG-${MY_PV}.tar.gz"
S="${WORKDIR}/${PN}-${MY_PV^^}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug devtools nls opengl profile +sound"
REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND="
	${LUA_DEPS}
	media-libs/libpng:=
	media-libs/libsdl[opengl?,sound?,video]
	>=media-libs/sdl-gfx-2.0.21:=
	media-libs/sdl-image[jpeg,png]
	sys-libs/zlib:=
	devtools? ( media-libs/sdl-ttf )
	nls? ( virtual/libintl )
	opengl? (
		media-libs/glew:0=
		virtual/opengl
	)
	sound? (
		media-libs/libogg
		media-libs/libvorbis
		media-libs/sdl-mixer[vorbis]
	)"
DEPEND="${RDEPEND}"
BDEPEND="
	${PYTHON_DEPS}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

PATCHES=(
	"${FILESDIR}/${P}-fnocommon.patch"
)

pkg_setup() {
	lua-single_pkg_setup
	python-any-r1_pkg_setup
}

src_prepare() {
	default

	python_fix_shebang src/gen_savestruct.py
	rm data/sound/speak.py || die # unused, prevent installing
}

src_configure() {
	local econfargs=(
		$(use_enable debug backtrace)
		$(use_enable debug)
		$(use_enable devtools dev-tools)
		$(use_enable nls)
		$(use_enable opengl)
		$(use_enable profile rtprof)
		$(use_enable sound)
		$(use_with debug extra-warnings)
	)
	econf "${econfargs[@]}"
}

pkg_postinst() {
	xdg_pkg_postinst

	if [[ ${REPLACING_VERSIONS} ]]; then
		local min="1.0_rc1"
		if ver_test ${REPLACING_VERSIONS} -lt ${min}; then
			elog "${P} is not compatible with save games before ${min}."
			elog "Please start a new character."
		fi
	fi
}
