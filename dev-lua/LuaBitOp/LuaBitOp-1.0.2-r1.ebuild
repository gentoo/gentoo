# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-{1..4} luajit )

inherit flag-o-matic lua toolchain-funcs

DESCRIPTION="Bit Operations Library for the Lua Programming Language"
HOMEPAGE="http://bitop.luajit.org"
SRC_URI="http://bitop.luajit.org/download/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 ~riscv sparc x86 ~x64-macos"
REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND="${LUA_DEPS}"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

HTML_DOCS=( "doc/." )

PATCHES=( "${FILESDIR}/${P}-support-lua5-3+.patch" )

src_prepare() {
	default

	lua_copy_sources
}

lua_src_compile() {
	pushd "${BUILD_DIR}" || die

	local myemakeargs=(
		"CC=$(tc-getCC)"
		"CCOPT="
		"INCLUDES=$(lua_get_CFLAGS)"
	)

	emake "${myemakeargs[@]}" all

	popd
}

src_compile() {
	if [[ $CHOST == *-darwin* ]] ; then
		append-ldflags "-undefined dynamic_lookup"
	fi
	lua_foreach_impl lua_src_compile
}

lua_src_test() {
	pushd "${BUILD_DIR}" || die

	local mytests=(
		"bitbench.lua"
		"bittest.lua"
		"md5test.lua"
		"nsievebits.lua"
	)

	for mytest in ${mytests[@]}; do
		LUA_CPATH="./?.so" ${ELUA} ${mytest}
	done

	popd
}

src_test() {
	lua_foreach_impl lua_src_test
}

lua_src_install() {
	pushd "${BUILD_DIR}" || die

	mycmoddir="$(lua_get_cmod_dir)"
	exeinto "${mycmoddir#$EPREFIX}"
	doexe bit.so

	popd

	if [[ ${CHOST} == *-darwin* ]] ; then
		local luav=$(lua_get_version)
		# we only want the major version (e.g. 5.1)
		local luamv=${luav:0:3}
		local file="lua/${luamv}/bit.so"
		install_name_tool \
			-id "${EPREFIX}/usr/$(get_libdir)/${file}" \
			"${ED}/usr/$(get_libdir)/${file}" \
			|| die "Failed to adjust install_name"
	fi
}

src_install() {
	lua_foreach_impl lua_src_install

	einstalldocs
}
