# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

# Below is the upstream package version.
# The final component of the version number has been mapped to the _px
# component of the version number in portage so should be kept in sync.
MY_PV="3.0-1"

DESCRIPTION="A command-line argument parser."
HOMEPAGE="https://github.com/amireh/lua_cliargs"
SRC_URI="https://github.com/amireh/${PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm ~ppc ~ppc64 x86"
IUSE=""

COMMON_DEPEND=">=dev-lang/lua-5.1:="
DEPEND="${COMMON_DEPEND}
virtual/pkgconfig"
RDEPEND="${COMMON_DEPEND}"

S="${WORKDIR}/${PN}-${MY_PV}"

src_install() {
	insinto "$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD lua)"
	doins -r src/cliargs.lua src/cliargs
	dodoc README.md
	dodoc -r examples
	docinto html
	dodoc -r doc/*
}
