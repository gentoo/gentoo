# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Pretty output handler for Busted"
HOMEPAGE="https://github.com/hishamhm/busted-htest"
SRC_URI="https://github.com/hishamhm/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE="luajit"

RDEPEND="
	luajit? ( dev-lang/luajit:2 )
	!luajit? ( >=dev-lang/lua-5.1:0 )
	dev-lua/busted
"

BDEPEND="virtual/pkgconfig"

src_install() {
	insinto $($(tc-getPKG_CONFIG) --variable INSTALL_LMOD $(usex luajit 'luajit' 'lua'))
	doins src/busted/outputHandlers/htest.lua

	einstalldocs
}
