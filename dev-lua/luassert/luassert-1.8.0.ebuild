# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Lua Assertions Extension"
HOMEPAGE="http://olivinelabs.com/busted/"
SRC_URI="https://github.com/Olivine-Labs/luassert/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
IUSE="luajit test"
RESTRICT="test" # Requires same version to be installed or busted will fail.

RDEPEND="
	>=dev-lua/say-1.3_p1[luajit(-)=]
	!luajit? ( >=dev-lang/lua-5.1:= )
	luajit? ( dev-lang/luajit:2 )
"

BDEPEND="
	virtual/pkgconfig
	test? (
		${RDEPEND}
		dev-lua/busted
	)
"

DEPEND="${RDEPEND}"

src_test() {
	busted -o gtest || die
}

src_install() {
	local instdir
	instdir="$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD $(usex luajit 'luajit' 'lua'))"/${PN}
	insinto "${instdir#${EPREFIX}}"
	doins -r src/*
	local -a DOCS=( CONTRIBUTING.md LICENSE README.md )
	einstalldocs
}
