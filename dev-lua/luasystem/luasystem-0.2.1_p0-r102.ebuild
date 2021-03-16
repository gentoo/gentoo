# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-{1..4} luajit )
MY_PV="${PV/_p/-}"

inherit lua toolchain-funcs

DESCRIPTION="Platform independent system calls for Lua"
HOMEPAGE="https://github.com/o-lim/luasystem/"
SRC_URI="https://github.com/o-lim/${PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ppc ppc64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="${LUA_DEPS}"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	test? (
		dev-lua/busted[${LUA_USEDEP}]
		${RDEPEND}
	)
"

PATCHES=( "${FILESDIR}"/${P}-fix-makefile.patch )

src_prepare() {
	default

	lua_copy_sources
}

lua_src_test() {
	busted --lua=${ELUA} || die
}

src_test() {
	lua_foreach_impl lua_src_test
}

lua_src_compile() {
	pushd "${BUILD_DIR}" || die

	local myemakeargs=(
		"CC=$(tc-getCC)"
		"LD=$(tc-getCC)"
		"LUAINC_linux=$(lua_get_include_dir)"
		"MYCFLAGS=${CFLAGS}"
		"MYLDFLAGS=${LDFLAGS}"
	)

	emake "${myemakeargs[@]}" linux

	popd
}

src_compile() {
	lua_foreach_impl lua_src_compile
}

lua_src_install () {
	pushd "${BUILD_DIR}" || die

	local emakeargs=(
		"INSTALL_TOP_CDIR=${ED}/$(lua_get_cmod_dir)"
		"INSTALL_TOP_LDIR=${ED}/$(lua_get_lmod_dir)"
		"LUA_INC=${ED}/$(lua_get_include_dir)"
	)

	emake "${emakeargs[@]}" install

	insinto $(lua_get_lmod_dir)/system
	doins system/init.lua

	popd
}

src_install() {
	lua_foreach_impl lua_src_install

	einstalldocs
}
