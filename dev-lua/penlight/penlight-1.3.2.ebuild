# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit toolchain-funcs

DESCRIPTION="Lua utility libraries loosely based on the Python standard libraries"
HOMEPAGE="http://stevedonovan.github.com/Penlight",
SRC_URI="http://stevedonovan.github.io/files/${PN}-1.3.2-core.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

COMMON_DEPEND=">=dev-lang/lua-5.1:="
DEPEND="${COMMON_DEPEND}
app-arch/unzip
	virtual/pkgconfig"
RDEPEND="${COMMON_DEPEND}
	dev-lua/luafilesystem"

src_install() {
	insinto "$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD lua)"
	doins -r lua/pl
}
