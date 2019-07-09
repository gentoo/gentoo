# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit toolchain-funcs

DESCRIPTION="David Kolf's JSON module for Lua"
HOMEPAGE="http://dkolf.de/src/dkjson-lua.fsl/"
SRC_URI="http://dkolf.de/src/dkjson-lua.fsl/tarball/${P}.tar.gz?uuid=release_2_5 -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm ppc ppc64 x86"
IUSE=""

COMMON_DEPEND=">=dev-lang/lua-5.1:=
	!>=dev-lang/lua-5.4"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig"
RDEPEND="${COMMON_DEPEND}"

src_install() {
	insinto "$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD lua)"
doins dkjson.lua
dodoc readme.txt
}
