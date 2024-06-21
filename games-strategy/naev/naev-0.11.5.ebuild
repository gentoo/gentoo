# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-1 luajit )
PYTHON_COMPAT=( python3_{10..13} )
inherit lua-single meson python-any-r1 virtualx xdg

DESCRIPTION="2D space trading and combat game, in a similar vein to Escape Velocity"
HOMEPAGE="https://naev.org/"
SRC_URI="https://github.com/naev/naev/releases/download/v${PV}/${P}-source.tar.xz"

LICENSE="
	GPL-3+
	Apache-2.0 BSD BSD-2 CC-BY-2.0 CC-BY-3.0 CC-BY-4.0 CC-BY-SA-3.0
	CC-BY-SA-4.0 CC0-1.0 GPL-2+ MIT OFL-1.1 public-domain
"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"
REQUIRED_USE="${LUA_REQUIRED_USE}"

# dlopen: libglvnd
RDEPEND="
	${LUA_DEPS}
	dev-games/physfs
	dev-libs/libpcre2:=
	dev-libs/libunibreak:=
	dev-libs/libxml2
	media-libs/freetype:2
	media-libs/libglvnd
	media-libs/libsdl2[joystick,opengl,video]
	media-libs/libvorbis
	media-libs/openal
	media-libs/sdl2-image[png,webp]
	net-libs/enet:1.3=
	sci-libs/cholmod
	sci-libs/cxsparse
	sci-libs/openblas
	sci-libs/suitesparse
	sci-mathematics/glpk:=
	virtual/libintl
"
DEPEND="
	${RDEPEND}
	test? (
		dev-games/physfs[zip]
		media-libs/libsdl2[X]
	)
"
BDEPEND="
	$(python_gen_any_dep 'dev-python/pyyaml[${PYTHON_USEDEP}]')
	sys-devel/gettext
	doc? (
		app-text/doxygen
		dev-lua/ldoc
		media-gfx/graphviz
	)
	test? (
		media-libs/mesa[llvm]
		x11-base/xorg-server[-minimal]
	)
"

python_check_deps() {
	python_has_version "dev-python/pyyaml[${PYTHON_USEDEP}]"
}

pkg_setup() {
	lua-single_pkg_setup
	python-any-r1_pkg_setup
}

src_prepare() {
	default

	# use eclass' generated lua.pc first rather than as fallback
	sed -i "s/'lua51'/'lua'/" meson.build || die

	# don't probe OpenGL for tests (avoids sandbox violations, bug #829369),
	# mesa[llvm] should ensure software rendering will work
	sed -i "/subdir('glcheck')/d" test/meson.build || die
}

src_configure() {
	local emesonargs=(
		$(meson_feature doc docs_c)
		$(meson_feature doc docs_lua)
		$(meson_feature lua_single_target_luajit luajit)
	)

	meson_src_configure
}

src_test() {
	virtx meson_src_test
}

src_install() {
	local DOCS=( CHANGELOG Readme.md )
	meson_src_install

	if use doc; then
		dodir /usr/share/doc/${PF}/html
		mv -- "${ED}"/usr/{doc/naev/{c,lua},share/doc/${PF}/html} || die
		rm -r -- "${ED}"/usr/doc || die
	fi

	rm -r -- "${ED}"/usr/share/doc/naev || die
}
