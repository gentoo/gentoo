# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
MY_PV=1.3-1

inherit toolchain-funcs

DESCRIPTION="Lua String Hashing/Indexing Library"
HOMEPAGE="http://olivinelabs.com/busted/"
SRC_URI="https://github.com/Olivine-Labs/${PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

COMMON_DEPEND=">=dev-lang/lua-5.1:*"
DEPEND="${COMMON_DEPEND}
virtual/pkgconfig"
RDEPEND="${COMMON_DEPEND}"

S="${WORKDIR}/${PN}-${MY_PV}"

DOCS=( CONTRIBUTING.md README.md )
src_install() {
	LUA_VERSION=$(readlink -e "${EROOT}"/usr/bin/lua | sed -ne 's:.*/usr/bin/lua\([\d.-]*\):\1:p')
	insinto "$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD lua)"/$LUA_VERSION/${PN}
doins src/init.lua
}
