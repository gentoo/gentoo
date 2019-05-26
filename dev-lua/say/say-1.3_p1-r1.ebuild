# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
MY_PV=1.3-1

inherit toolchain-funcs

DESCRIPTION="Lua String Hashing/Indexing Library"
HOMEPAGE="http://olivinelabs.com/busted/"
SRC_URI="https://github.com/Olivine-Labs/${PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm ppc ppc64 x86"
IUSE="luajit test"

RDEPEND="
	!luajit? ( >=dev-lang/lua-5.1:= )
	luajit? ( dev-lang/luajit:2 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	test? ( dev-lua/busted )"

DOCS=( CONTRIBUTING.md README.md )

S="${WORKDIR}/${PN}-${MY_PV}"

src_test() {
	busted -o gtest || die
}

src_install() {
	local instdir
	instdir="$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD $(usex luajit 'luajit' 'lua'))"/${PN}
	insinto "${instdir#${EPREFIX}}"
	doins src/init.lua
	einstalldocs
}
