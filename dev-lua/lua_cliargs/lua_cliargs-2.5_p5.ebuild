# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit toolchain-funcs

# Below is the upstream package version.
# The final component of the version number has been mapped to the _px
# component of the version number in portage so should be kept in sync.
MY_PV="2.5-5"

DESCRIPTION="A command-line argument parser."
HOMEPAGE="https://github.com/amireh/lua_cliargs"
SRC_URI="https://github.com/amireh/${PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

COMMON_DEPEND=">=dev-lang/lua-5.1:="
DEPEND="${COMMON_DEPEND}
virtual/pkgconfig"
RDEPEND="${COMMON_DEPEND}"

S="${WORKDIR}/${PN}-${MY_PV}"

src_install() {
	insinto "$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD lua)"
	doins src/cliargs.lua
	dodoc README.md
dodoc -r examples
	docinto html
	dodoc -r doc/*
}
