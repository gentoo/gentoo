# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-1 luajit )
PYTHON_COMPAT=( python3_{8..10} )
inherit lua-single meson python-any-r1 virtualx xdg

DESCRIPTION="2D space trading and combat game, in a similar vein to Escape Velocity"
HOMEPAGE="https://naev.org/"
SRC_URI="https://github.com/naev/naev/releases/download/v${PV}/${P}-source.tar.xz"
S="${WORKDIR}/${PN}-0.9.2" # 0.9.3 tarball uses wrong directory

LICENSE="
	GPL-3+ BSD BSD-2 CC-BY-2.0 CC-BY-3.0 CC-BY-4.0 CC-BY-SA-2.0
	CC-BY-SA-3.0 CC-BY-SA-4.0 CC0-1.0 MIT public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"
REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND="
	${LUA_DEPS}
	dev-games/physfs
	dev-libs/libunibreak:=
	dev-libs/libxml2
	media-libs/freetype:2
	media-libs/libsdl2[joystick,opengl,video]
	media-libs/libvorbis
	media-libs/openal
	media-libs/sdl2-image[png,webp]
	sci-libs/cholmod
	sci-libs/cxsparse
	sci-libs/openblas
	sci-libs/suitesparse
	sci-mathematics/glpk:=
	virtual/libintl
	virtual/opengl"
DEPEND="
	${RDEPEND}
	test? (
		dev-games/physfs[zip]
		media-libs/libsdl2[X]
		media-libs/mesa[llvm]
	)"
BDEPEND="
	$(python_gen_any_dep 'dev-python/pyyaml[${PYTHON_USEDEP}]')
	sys-devel/gettext
	doc? (
		app-doc/doxygen[dot]
		dev-lua/ldoc
	)"

python_check_deps() {
	python_has_version "dev-python/pyyaml[${PYTHON_USEDEP}]"
}

pkg_setup() {
	lua-single_pkg_setup
	python-any-r1_pkg_setup
}

src_prepare() {
	default

	sed -i "s/'lua51'/'lua'/" meson.build || die
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
		mv "${ED}"/usr/{doc/naev/{c,lua},share/doc/${PF}/html} || die
		rm -r "${ED}"/usr/doc || die
	fi
	rm -r "${ED}"/usr/share/doc/naev || die
}
