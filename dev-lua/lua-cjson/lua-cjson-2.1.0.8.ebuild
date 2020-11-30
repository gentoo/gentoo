# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="A fast JSON encoding/parsing module for Lua"
HOMEPAGE="https://www.kyne.com.au/~mark/software/lua-cjson.php https://github.com/openresty/lua-cjson"
SRC_URI="https://github.com/openresty/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="+internal-fpconv luajit test +threads"
RESTRICT="!test? ( test )"
REQUIRED_USE="threads? ( internal-fpconv )"

RDEPEND="
	luajit? ( dev-lang/luajit:2 )
	!luajit? ( dev-lang/lua:0 )
"

DEPEND="${RDEPEND}"
BDEPEND="test? ( dev-lang/perl )"

DOCS=( "manual.txt" "NEWS" "performance.txt" "README.md" "THANKS" )

PATCHES=( "${FILESDIR}/${PN}-2.1.0.8-sparse_array_test_fix.patch" )

src_prepare() {
	default

	# Don't install tests
	sed -e '/cd tests/d' -i Makefile || die
}

src_compile() {
	local myemakeargs=(
		"CC=$(tc-getCC)"
		"CFLAGS=${CFLAGS}"
		"LDFLAGS=${LDFLAGS}"
		"LUA_INCLUDE_DIR=$($(tc-getPKG_CONFIG) --variable $(usex luajit 'includedir' 'INSTALL_INC') $(usex luajit 'luajit' 'lua'))"
	)

	emake "${myemakeargs[@]}"
}

src_test() {
	cd tests || die

	ln -s "${S}"/cjson.so ./ || die
	ln -s "${S}"/lua/cjson ./ || die

	./genutf8.pl || die
	./test.lua || die
}

src_install() {
	local myemakeargs=(
		"DESTDIR=${D}"
		"LUA_CMODULE_DIR=$($(tc-getPKG_CONFIG) --variable INSTALL_CMOD $(usex luajit 'luajit' 'lua'))"
		"LUA_MODULE_DIR=$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD $(usex luajit 'luajit' 'lua'))"
		"PREFIX=${EPREFIX}/usr"
	)

	emake "${myemakeargs[@]}" install install-extra

	einstalldocs
}
