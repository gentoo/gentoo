# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VIRTUALX_REQUIRED="manual"
LUA_COMPAT=( lua5-{1..4} luajit )
inherit lua meson virtualx

DESCRIPTION="Lua bindings using gobject-introspection"
HOMEPAGE="https://github.com/lgi-devs/lgi"
if [[ ${PV} == *_p* ]]; then
	HASH_COMMIT="a1308b23b07a787d21fad86157b0b60eb3079f64"
	SRC_URI="https://github.com/lgi-devs/lgi/archive/${HASH_COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-${HASH_COMMIT}"
else
	SRC_URI="https://github.com/lgi-devs/lgi/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"
IUSE="test"
RESTRICT="!test? ( test )"
REQUIRED_USE="${LUA_REQUIRED_USE}"

BDEPEND="
	${LUA_DEPS}
	virtual/pkgconfig
	test? (
		${VIRTUALX_DEPEND}
		sys-apps/dbus
		x11-misc/xvfb-run
	)
"
RDEPEND="
	${LUA_DEPS}
	>=dev-libs/gobject-introspection-1.82.0-r2
	dev-libs/glib:2
	dev-libs/libffi:0=
"
DEPEND="
	${RDEPEND}
	test? (
		x11-libs/cairo[glib,X]
		|| (
			x11-libs/gtk+:3[introspection,X]
			gui-libs/gtk:4[introspection,X]
		)
	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.9.2-multi_lua_impl.patch
	"${FILESDIR}"/${PN}-0.9.2-fix_tests.patch
)

lua_src_prepare() {
	pushd "${BUILD_DIR}" || die
	#  lgi/meson.build & several source files use the LUA version as part of the
	# direct filename, dynamically created, and we respect that.

	# replace @GENTOO_LUA_VERSION@ with lua version in patched files:
	# lgi/core.c:luaopen_lgi_corelgilua51 (lua_State* L)
	# lgi/core.lua:local core = require 'lgi.corelgilua51'
	# lgi/meson.build: liblgi = shared_module('corelgilua51'
	sed -i \
		-e "s/@GENTOO_LUA_VERSION@/${ELUA/.}/" \
		lgi/core.c \
		lgi/core.lua \
		lgi/meson.build \
		|| die "sed failed"

	popd
}

src_prepare() {
	default
	lua_copy_sources
	lua_foreach_impl lua_src_prepare
}

lua_src_configure() {
	local emesonargs=(
		-Dlua-pc="${ELUA}"
		-Dlua-bin="${LUA}"
		$(meson_use test tests)
	)
	EMESON_SOURCE="${BUILD_DIR}" \
	BUILD_DIR="${BUILD_DIR}-meson" \
	meson_src_configure
}

src_configure() {
	lua_foreach_impl lua_src_configure
}

lua_src_compile() {
	EMESON_SOURCE="${BUILD_DIR}" \
	BUILD_DIR="${BUILD_DIR}-meson" \
	meson_src_compile
}

src_compile() {
	lua_foreach_impl lua_src_compile
}

lua_src_test() {
	if [[ ${ELUA} == luajit ]]; then
		einfo "Tests are currently not supported on LuaJIT"
	else
		BUILD_DIR="${BUILD_DIR}-meson" \
		virtx meson_src_test
	fi
}

src_test() {
	lua_foreach_impl lua_src_test
}

lua_src_install() {
	BUILD_DIR="${BUILD_DIR}-meson" \
	meson_install
}

src_install() {
	lua_foreach_impl lua_src_install
	local DOCS=( README.md docs/. samples )
	docompress -x /usr/share/doc/${PF}/samples
	einstalldocs
}
