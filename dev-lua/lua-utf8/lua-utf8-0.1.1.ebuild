# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs

DESCRIPTION="UTF-8 support for Lua"
HOMEPAGE="https://github.com/starwing/luautf8"
SRC_URI="https://github.com/starwing/luautf8/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc64"
IUSE="luajit test"

RESTRICT="!test? ( test )"

BDEPEND="virtual/pkgconfig"
RDEPEND="
	!luajit? ( >=dev-lang/lua-5.1:= )
	luajit? ( dev-lang/luajit:2 )"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN//-/}-${PV}"

src_prepare() {
	default

	cp -v "${FILESDIR}/${PN}".Makefile "${S}"/Makefile || die
}

src_compile() {
	tc-export CC
	emake DESTDIR="${D}" PREFIX="${EPREFIX}" MY_USE_LUA="$(usex luajit 'luajit' 'lua')" PKG_CONFIG="$(tc-getPKG_CONFIG)"
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}" MY_USE_LUA="$(usex luajit 'luajit' 'lua')" PKG_CONFIG="$(tc-getPKG_CONFIG)" install
	einstalldocs
}

src_test() {
	LUA_CPATH=./?.so $(usex luajit 'luajit' 'lua') test.lua || die
}
