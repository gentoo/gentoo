# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-{1..4} luajit )

inherit lua toolchain-funcs

DESCRIPTION="A fast JSON encoding/parsing module for Lua"
HOMEPAGE="https://www.kyne.com.au/~mark/software/lua-cjson.php https://github.com/openresty/lua-cjson"
SRC_URI="https://github.com/openresty/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="+internal-fpconv test +threads"
REQUIRED_USE="
	threads? ( internal-fpconv )
	${LUA_REQUIRED_USE}
"
RESTRICT="!test? ( test )"

RDEPEND="${LUA_DEPS}"
DEPEND="${RDEPEND}"
BDEPEND="test? ( dev-lang/perl )"

DOCS=( "manual.txt" "NEWS" "performance.txt" "README.md" "THANKS" )

PATCHES=(
	"${FILESDIR}/${PN}-2.1.0.8-sparse_array_test_fix.patch"
	"${FILESDIR}/${PN}-2.1.0.8-lua52.patch"
)

src_prepare() {
	default

	# Don't install tests
	sed -e '/cd tests/d' -i Makefile || die

	lua_copy_sources
}

lua_src_compile() {
	pushd "${BUILD_DIR}" || die

	local myemakeargs=(
		"CC=$(tc-getCC)"
		"CFLAGS=${CFLAGS}"
		"LDFLAGS=${LDFLAGS}"
		"LUA_INCLUDE_DIR=$(lua_get_include_dir)"
	)

	emake "${myemakeargs[@]}"

	popd
}

src_compile() {
	lua_foreach_impl lua_src_compile
}

lua_src_test() {
	if ! [[ ${ELUA} == "lua5.3" || ${ELUA} == "lua5.4" ]]; then
		pushd "${BUILD_DIR}" || die
		cd tests || die

		ln -s "${BUILD_DIR}"/cjson.so ./ || die
		ln -s "${S}"/lua/cjson ./ || die

		./genutf8.pl || die
		./test.lua || die

		popd
	else
		ewarn "Not running tests under ${ELUA} because they are known to fail"
		ewarn "See: https://github.com/openresty/lua-cjson/pull/50"
		return
	fi
}

src_test() {
	lua_foreach_impl lua_src_test
}

lua_src_install() {
	pushd "${BUILD_DIR}" || die

	local myemakeargs=(
		"DESTDIR=${D}"
		"LUA_CMODULE_DIR=$(lua_get_lmod_dir)"
		"LUA_MODULE_DIR=$(lua_get_lmod_dir)"
		"PREFIX=${EPREFIX}/usr"
	)

	emake "${myemakeargs[@]}" install install-extra

	popd
}

src_install() {
	lua_foreach_impl lua_src_install

	einstalldocs
}
