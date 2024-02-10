# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-{1..4} luajit )

inherit lua toolchain-funcs

DESCRIPTION="Offers basic cryptographic facilities for Lua"
HOMEPAGE="https://github.com/keplerproject/md5"
SRC_URI="https://github.com/keplerproject/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND="${LUA_DEPS}"
DEPEND="${RDEPEND}"

src_prepare() {
	default

	lua_copy_sources
}

src_configure() {
	# Provided 'configure' script is useless.
	:;
}

lua_src_compile() {
	pushd "${BUILD_DIR}" || die

	local myemakeargs=(
		"CC=$(tc-getCC)"
		"CFLAGS=${CFLAGS} -fPIC $(lua_get_CFLAGS) ${LDFLAGS}"
	)

	emake "${myemakeargs[@]}"

	popd
}

src_compile() {
	lua_foreach_impl lua_src_compile
}

lua_src_test() {
	pushd "${BUILD_DIR}/src" || die

	# Workaround for tests.
	ln -s core.so md5.so || die

	"${ELUA}" ../tests/test.lua

	popd
}

src_test() {
	lua_foreach_impl lua_src_test
}

lua_src_install() {
	pushd "${BUILD_DIR}" || die

	# Workaround, as 'Makefile' does not create this directory.
	dodir "$(lua_get_cmod_dir)"

	local myemakeargs=(
		"LUA_DIR=${ED}/$(lua_get_lmod_dir)"
		"LUA_LIBDIR=${ED}/$(lua_get_cmod_dir)"
	)

	emake "${myemakeargs[@]}" install

	popd
}

src_install() {
	lua_foreach_impl lua_src_install

	einstalldocs
}
