# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

VIRTUALX_REQUIRED="manual"
LUA_COMPAT=( lua5-{1..4} luajit )

inherit lua eutils toolchain-funcs flag-o-matic virtualx

DESCRIPTION="Lua bindings using gobject-introspection"
HOMEPAGE="https://github.com/pavouk/lgi"
SRC_URI="https://github.com/pavouk/lgi/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm ppc ppc64 x86"
IUSE="examples test"
RESTRICT="!test? ( test )"
REQUIRED_USE="${LUA_REQUIRED_USE}"

BDEPEND="${LUA_DEPS}"
RDEPEND="${LUA_DEPS}
		dev-libs/gobject-introspection
		dev-libs/glib
		dev-libs/libffi:0="
DEPEND="${RDEPEND}
		test? (
			x11-libs/cairo[glib]
			x11-libs/gtk+[introspection]
			${VIRTUALX_DEPEND}
		)"

PATCHES=( "${FILESDIR}/${P}-lua54.patch" )

lua_src_prepare() {
	pushd "${BUILD_DIR}" || die
	# The Makefile & several source files use the LUA version as part of the
	# direct filename, dynamically created, and we respect that.
	_slug=${ELUA}
	_slug=${_slug/.}
	_slug=${_slug/-}
	_slug=${_slug/_}

	# Makefile: CORE = corelgilua51.so (and similar lines)
	sed -r -i \
		-e "/^CORE\>/s,lua5.,${_slug},g" \
		lgi/Makefile \
		|| die "sed failed"

	# ./lgi/core.lua:local core = require 'lgi.corelgilua51'
	# ./lgi/core.c:luaopen_lgi_corelgilua51 (lua_State* L)
	sed -r -i \
		-e "/lgi.corelgilua5./s,lua5.,${_slug},g" \
		lgi/core.lua \
		lgi/core.c \
		|| die "sed failed"

	# Verify the change as it's important!
	for f in lgi/core.lua lgi/core.c lgi/Makefile ; do
		grep -sq "corelgi${_slug}" "${f}" || die "Failed to sed .lua & .c for corelgi${_slug}: ${f}"
	done

	# Cleanup
	unset _slug
	popd
}

src_prepare() {
	default
	lua_copy_sources
	lua_foreach_impl lua_src_prepare
}

lgi_emake_wrapper() {
	emake \
	CC="$(tc-getCC)" \
	COPTFLAGS="-Wall -Wextra ${CFLAGS}" \
	LIBFLAG="-shared ${LDFLAGS}" \
	LUA_CFLAGS="$(lua_get_CFLAGS)" \
	LUA="${LUA}" \
	LUA_VERSION="${ELUA#lua}" \
	LUA_LIBDIR="$(lua_get_cmod_dir)" \
	LUA_SHAREDIR="$(lua_get_lmod_dir)" \
	"$@"
}

lua_src_compile() {
	pushd "${BUILD_DIR}" || die
	lgi_emake_wrapper all
	popd
}

src_compile() {
	lua_foreach_impl lua_src_compile
}

lua_src_test() {
	pushd "${BUILD_DIR}" || die
	virtx \
		lgi_emake_wrapper \
		check
	popd
}

src_test() {
	lua_foreach_impl lua_src_test
}

lua_src_install() {
	pushd "${BUILD_DIR}" || die
	lgi_emake_wrapper \
		DESTDIR="${D}" \
		install
	popd
}

src_install() {
	lua_foreach_impl lua_src_install
	docompress -x /usr/share/doc/${PF}
	dodoc README.md
	dodoc -r docs/*
	if use examples; then
		dodoc -r samples
	fi
}
