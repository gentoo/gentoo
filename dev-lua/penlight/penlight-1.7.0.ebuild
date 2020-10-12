# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Lua utility libraries loosely based on the Python standard libraries"
HOMEPAGE="https://github.com/Tieske/Penlight",
SRC_URI="https://github.com/Tieske/Penlight/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE=""

BDEPEND="virtual/pkgconfig"
RDEPEND=">=dev-lang/lua-5.1:=
	dev-lua/luafilesystem"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN//penlight/Penlight}-${PV}"

src_install() {
	local -a DOCS=( README.md CHANGELOG.md LICENSE.md CONTRIBUTING.md )
	einstalldocs

	insinto "$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD lua)"
	doins -r lua/pl
}
