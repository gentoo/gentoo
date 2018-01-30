# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Parsing Expression Grammars for Lua"
HOMEPAGE="http://www.inf.puc-rio.br/~roberto/lpeg/"
SRC_URI="http://www.inf.puc-rio.br/~roberto/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 hppa ppc ppc64 x86"
IUSE="debug doc luajit"

RDEPEND="
	!luajit? ( >=dev-lang/lua-5.1:= )
	luajit? ( dev-lang/luajit:2= )"

DEPEND="
	${RDEPEND}
	virtual/pkgconfig"

DOCS=( "HISTORY" )
HTML_DOCS=( "lpeg.html"  "re.html"  )
PATCHES=( "${FILESDIR}"/${PN}-0.12.1-makefile.patch )

src_prepare() {
	default
	use debug && append-cflags -DLPEG_DEBUG
}

src_compile() {
	emake CC="$(tc-getCC)" \
		LUADIR="$($(tc-getPKG_CONFIG) --variable includedir $(usex luajit 'luajit' 'lua'))"
}

src_test() {
	$(usex luajit 'luajit' 'lua') test.lua || die
}

src_install() {
	local instdir
	instdir="$($(tc-getPKG_CONFIG) --variable INSTALL_CMOD $(usex luajit 'luajit' 'lua'))"
	exeinto "${instdir#${EPREFIX}}"
	doexe lpeg.so
	instdir="$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD $(usex luajit 'luajit' 'lua'))"
	insinto "${instdir#${EPREFIX}}"
	doins re.lua

	use doc && einstalldocs
}
