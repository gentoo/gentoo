# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGIT_COMMIT_AUX="8d09895473b73e4fb72b7573615f69c36e1860a2"
LUA_COMPAT=( lua5-{1..4} luajit )
MY_PN_AUX="lua-auxiliar"
MY_PN_COMPAT="lua-compat-5.3"
MY_PV="${PV//_p/-}"
MY_PV_COMPAT="0.10"

inherit lua toolchain-funcs

DESCRIPTION="OpenSSL binding for Lua"
HOMEPAGE="https://github.com/zhaozg/lua-openssl"
SRC_URI="
	https://github.com/zhaozg/${PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz
	https://github.com/zhaozg/${MY_PN_AUX}/archive/${EGIT_COMMIT_AUX}.tar.gz -> ${MY_PN_AUX}-${EGIT_COMMIT_AUX}.tar.gz
	https://github.com/keplerproject/${MY_PN_COMPAT}/archive/v${MY_PV_COMPAT}.tar.gz -> ${MY_PN_COMPAT}-${MY_PV_COMPAT}.tar.gz
"
S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="MIT openssl PHP-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="libressl test"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RESTRICT="!test? ( test )"

RDEPEND="
	!dev-lua/luaossl
	!dev-lua/luasec
	libressl? ( dev-libs/libressl:0= )
	!libressl? ( dev-libs/openssl:0=[-bindist] )
	${LUA_DEPS}
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	test? ( ${RDEPEND} )
"

DOCS=( "README.md" "samples/." )

src_prepare() {
	default

	# Allow override of LUA* variables
	sed -e '/LUA  /s/:=/?=/g' -e '/LUA_VERSION/s/:=/?=/g' -i Makefile || die

	# Prepare needed dependencies (source code files only)
	rm -r deps/{auxiliar,lua-compat} || die
	mv "${WORKDIR}/${MY_PN_AUX}-${EGIT_COMMIT_AUX}" deps/auxiliar || die
	mv "${WORKDIR}/${MY_PN_COMPAT}-${MY_PV_COMPAT}" deps/lua-compat || die

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

	insinto "$(lua_get_lmod_dir)"
	doins -r "lib/."

	popd
}

src_install() {
	lua_foreach_impl lua_src_install

	einstalldocs
}
