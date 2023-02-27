# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-1 luajit )

inherit lua-single toolchain-funcs xdg

DESCRIPTION="A fast, extensible, and customizable web browser"
HOMEPAGE="https://luakit.github.io/luakit"

SRC_URI="https://github.com/luakit/luakit/archive/${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~arm64"

LICENSE="GPL-3+"
SLOT="0"
IUSE="doc test"

REQUIRED_USE="${LUA_REQUIRED_USE}"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-db/sqlite:3
	dev-libs/glib:2
	net-libs/webkit-gtk:4.1=
	x11-libs/gtk+:3
	${LUA_DEPS}
	$(lua_gen_cond_dep '
		dev-lua/luafilesystem[${LUA_USEDEP}]
	')
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	doc? (
		dev-lua/luafilesystem
		app-doc/doxygen
		media-gfx/graphviz
	)
	test? (
		$(lua_gen_cond_dep '
			dev-lua/luassert[${LUA_USEDEP}]
			dev-lua/luacheck[${LUA_USEDEP}]
		')
		x11-base/xorg-server[xvfb]
	)
"
src_configure() {
	export LUA_BIN_NAME=${ELUA}
	export LUA_PKG_NAME=${ELUA}
	tc-export CC PKG_CONFIG
}

src_compile() {
	emake \
		PREFIX="${EPREFIX}/usr" \
		USE_LUAJIT=$(usex lua_single_target_luajit 1 0) \
		${PN} ${PN}.so

	use doc && emake doc
}

src_test() {
	local failing_test
	for failing_test in test_clib_luakit test_image_css; do
		mv tests/async/${failing_test}.lua{,.disabled} || die
	done

	emake \
		USE_LUAJIT=$(usex lua_single_target_luajit 1 0) \
		run-tests
}

src_install() {
	emake \
		DESTDIR="${ED}" \
		DOCDIR="${EPREFIX}/usr/share/doc/${PF}" \
		PREFIX="${EPREFIX}/usr" \
		USE_LUAJIT=$(usex lua_single_target_luajit 1 0) \
		XDGPREFIX="${EPREFIX}/etc/xdg" \
		install

	rm "${ED}/usr/share/doc/${PF}/COPYING.GPLv3" || die

	use doc && dodoc -r doc/html
}
