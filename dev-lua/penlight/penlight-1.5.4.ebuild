# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Lua utility libraries loosely based on the Python standard libraries"
HOMEPAGE="http://stevedonovan.github.io/Penlight"
SRC_URI="https://github.com/stevedonovan/Penlight/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86"
IUSE=""

COMMON_DEPEND=">=dev-lang/lua-5.1:*"
DEPEND="${COMMON_DEPEND}
app-arch/unzip
	virtual/pkgconfig"
RDEPEND="${COMMON_DEPEND}
	dev-lua/luafilesystem"

S="${WORKDIR}/Penlight-${PV}"

src_install() {
	LUA_VERSION=$(readlink -e "${EROOT}"/usr/bin/lua | sed -ne 's:.*/usr/bin/lua\([\d.-]*\):\1:p')
	insinto "$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD lua)/$LUA_VERSION"
	doins -r lua/pl
}
