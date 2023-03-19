# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-{1..4} luajit )

inherit lua toolchain-funcs

MY_PN="lib${PN}-lua"

DESCRIPTION="Lua bindings for libmpack"
HOMEPAGE="https://github.com/libmpack/libmpack-lua/"
SRC_URI="https://github.com/${MY_PN/-lua/}/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~sparc ~x86 ~x64-macos"
IUSE="test"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/libmpack
	${LUA_DEPS}
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	test? (
		dev-lua/busted[${LUA_USEDEP}]
		dev-lua/lua_cliargs[${LUA_USEDEP}]
		${RDEPEND}
	)
"

src_prepare() {
	default

	lua_copy_sources
}

lua_src_compile() {
	pushd "${BUILD_DIR}" || die

	local myemakeargs=(
		"CC=$(tc-getCC)"
		"LUA_INCLUDE=$(lua_get_CFLAGS)"
		"LUA_LIB="
		"USE_SYSTEM_MPACK=yes"
		"USE_SYSTEM_LUA=yes"
	)

	emake "${myemakeargs[@]}"

	popd
}

src_compile() {
	lua_foreach_impl lua_src_compile
}

lua_src_test() {
	pushd "${BUILD_DIR}" || die

	# "[  FAILED  ] test.lua @ 279: mpack should not leak memory"
	# It doesn't seem upstream actually support LuaJIT so were this up to me
	# I would drop it from LUA_COMPAT, unfortunately there are packages in the
	# tree which currently expect it to be supported.
	if [[ ${ELUA} == "luajit" ]]; then
		ewarn "Not running tests under ${ELUA} because they are known to fail"
		return
	fi

	busted --lua="${ELUA}" test.lua || die

	popd
}

src_test() {
	lua_foreach_impl lua_src_test
}

lua_src_install() {
	pushd "${BUILD_DIR}" || die

	local installdir="$(lua_get_cmod_dir)"
	local myemakeargs=(
		"DESTDIR=${ED}"
		"LUA_CMOD_INSTALLDIR=${installdir#$EPREFIX}"
		"USE_SYSTEM_MPACK=yes"
		"USE_SYSTEM_LUA=yes"
	)

	emake "${myemakeargs[@]}" install

	popd

	if [[ ${CHOST} == *-darwin* ]] ; then
		local luav=$(lua_get_version)
		# we only want the major version (e.g. 5.1)
		local luamv=${luav:0:3}
		local file="lua/${luamv}/mpack.so"
		install_name_tool -id "${EPREFIX}/usr/$(get_libdir)/${file}" "${ED}/usr/$(get_libdir)/${file}" || die "Failed to adjust install_name"
	fi
}

src_install() {
	lua_foreach_impl lua_src_install

	einstalldocs
}
