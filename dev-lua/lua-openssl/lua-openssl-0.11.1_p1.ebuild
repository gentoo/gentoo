# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-{1..4} luajit )
MY_PV="${PV//_p/-}"

inherit lua toolchain-funcs

DESCRIPTION="OpenSSL binding for Lua"
HOMEPAGE="https://github.com/zhaozg/lua-openssl"
# release tarball bundles the lua-auxiliar and lua-compat-5.3 submodules
SRC_URI="https://github.com/zhaozg/${PN}/releases/download/${MY_PV}/openssl-${MY_PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/openssl-${MY_PV}"

LICENSE="MIT openssl PHP-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE="test"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RESTRICT="!test? ( test )"

RDEPEND="
	!dev-lua/luaossl
	!dev-lua/luasec
	dev-libs/openssl:0=[-bindist(-)]
	${LUA_DEPS}
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default

	# Skip the Makefile's auto-detection (it runs luajit/lua), we pass LUA_VERSION
	sed -e '/LUA_VERSION/s/:=/?=/g' -i Makefile || die

	lua_copy_sources
}

lua_src_compile() {
	pushd "${BUILD_DIR}" || die

	local myemakeargs=(
		"AR=$(tc-getAR)"
		"CC=$(tc-getCC)"
		"LUA="
		"LUA_CFLAGS=${CFLAGS} $(lua_get_CFLAGS)"
		"LUA_LIBS=${LDFLAGS}"
		"LUA_VERSION=$(ver_cut 1-2 $(lua_get_version))"
		"TARGET_SYS=${CTARGET:-${CHOST}}"
	)

	emake "${myemakeargs[@]}"

	popd
}

src_compile() {
	lua_foreach_impl lua_src_compile
}

lua_src_test() {
	pushd "${BUILD_DIR}" || die

	local myemakeargs=(
		"LUA=${ELUA}"
		"LUA_CFLAGS="
		"LUA_LIBS="
		"LUA_VERSION=$(ver_cut 1-2 $(lua_get_version))"
		"TARGET_SYS=${CTARGET:-${CHOST}}"
	)

	emake "${myemakeargs[@]}" test

	popd
}

src_test() {
	lua_foreach_impl lua_src_test
}

lua_src_install() {
	pushd "${BUILD_DIR}" || die

	local myemakeargs=(
		"LUA="
		"LUA_CFLAGS="
		"LUA_LIBDIR=${ED}/$(lua_get_cmod_dir)"
		"LUA_LIBS="
		"LUA_VERSION=$(ver_cut 1-2 $(lua_get_version))"
		"TARGET_SYS=${CTARGET:-${CHOST}}"
	)

	emake "${myemakeargs[@]}" install

	popd
}

src_install() {
	lua_foreach_impl lua_src_install

	einstalldocs
}
