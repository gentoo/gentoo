# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( luajit )
PYTHON_COMPAT=( python3_{11..14} )
inherit lua-single meson python-any-r1 xdg

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

# tests are very basic, equivalent to just starting the game and checking if
# can see the main menu -- but this breaks easily with software rendering and
# some Xorg/mesa versions, simpler to do manually than try to keep this working
RESTRICT="test"

# dlopen: libglvnd
RDEPEND="
	${LUA_DEPS}
	app-text/cmark:=
	dev-games/physfs
	dev-libs/libpcre2:=
	dev-libs/libunibreak:=
	dev-libs/libxml2:=
	dev-libs/libyaml
	dev-libs/nativefiledialog-extended
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
DEPEND="${RDEPEND}"
BDEPEND="
	$(python_gen_any_dep 'dev-python/pyyaml[${PYTHON_USEDEP}]')
	sys-devel/gettext
	doc? (
		app-text/doxygen
		dev-lua/ldoc
		media-gfx/graphviz
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

	# don't probe OpenGL for tests (avoids sandbox violations, bug #829369)
	sed -i "/subdir('glcheck')/d" test/meson.build || die
}

src_configure() {
	local emesonargs=(
		# *can* do lua5-1 but upstream uses+test luajit most (bug #946881)
		-Dluajit=enabled
		$(meson_feature doc docs_c)
		$(meson_feature doc docs_lua)
	)

	meson_src_configure
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
