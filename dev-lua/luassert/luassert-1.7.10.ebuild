# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Lua Assertions Extension"
HOMEPAGE="http://olivinelabs.com/busted/"
SRC_URI="https://github.com/Olivine-Labs/luassert/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
IUSE="luajit test"

CDEPEND="
	!luajit? ( >=dev-lang/lua-5.1:= )
	luajit? ( dev-lang/luajit:2 )"
RDEPEND="${CDEPEND}
	>=dev-lua/say-1.2_p1[luajit=]"
DEPEND="${CDEPEND}
	virtual/pkgconfig
	test? ( dev-lua/busted )"

DOCS=( CONTRIBUTING.md README.md )

src_test() {
	busted -o gtest || die
}

src_install() {
	local instdir
	instdir="$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD $(usex luajit 'luajit' 'lua'))"/${PN}
	insinto "${instdir#${EPREFIX}}"
	doins -r src/*
	einstalldocs
}
