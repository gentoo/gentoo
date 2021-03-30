# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-1 luajit )
PYTHON_COMPAT=( python3_{7..9} )
inherit lua-single meson python-any-r1 virtualx xdg

DESCRIPTION="A 2D space trading and combat game, in a similar vein to Escape Velocity"
HOMEPAGE="https://naev.org/ https://github.com/naev/naev"
SRC_URI="https://github.com/naev/naev/releases/download/v${PV}/${P}-source.tar.gz"

LICENSE="GPL-3 public-domain CC-BY-3.0 CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc +mixer nls +openal"
REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND="
	${LUA_DEPS}
	dev-libs/libzip
	dev-libs/libxml2
	media-libs/libsdl2[opengl,sound,video,X]
	media-libs/libpng:0=
	media-libs/freetype:2
	sci-libs/suitesparse
	virtual/glu
	virtual/opengl
	mixer? ( media-libs/sdl2-mixer )
	nls? ( virtual/libintl )
	openal? (
		media-libs/libvorbis
		media-libs/openal
	)"
DEPEND="${RDEPEND}"
BDEPEND="
	${PYTHON_DEPS}
	doc? (
		app-doc/doxygen
		dev-lua/ldoc
	)
	nls? ( sys-devel/gettext )"

pkg_setup() {
	lua-single_pkg_setup
	python-any-r1_pkg_setup
}

src_prepare() {
	default
	sed -i -e "s:lua51:lua5.1:g" meson.build || die
	# meson can't into docdir!
	sed -i -e "s:doc/naev:doc/${PF}:g" meson.build || die
	sed -i -e "s:'doc/naev':get_option('datadir') / 'doc/${PF}':g" docs/meson.build || die
	# remove license file from install
	sed -i -e "/'LICENSE'/d" meson.build || die
}

src_configure() {
	local emesonargs=(
		$(meson_feature doc docs_c)
		$(meson_feature doc docs_lua)
		$(meson_feature lua_single_target_luajit luajit)
		$(meson_feature nls)
		$(meson_feature openal)
		$(meson_feature mixer sdl_mixer)
	)
	meson_src_configure
}

src_test() {
	virtx meson_src_test
}
