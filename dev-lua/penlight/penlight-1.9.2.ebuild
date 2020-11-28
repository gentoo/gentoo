# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="Penlight"

inherit toolchain-funcs

DESCRIPTION="Lua utility libraries loosely based on the Python standard libraries"
HOMEPAGE="https://github.com/Tieske/Penlight",
SRC_URI="https://github.com/Tieske/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND=">=dev-lang/lua-5.1:="

RDEPEND="
	dev-lua/luafilesystem
	${DEPEND}
"

BDEPEND="
	virtual/pkgconfig
	test? ( ${DEPEND} )
"

HTML_DOCS=( "docs/." )

src_test() {
	# This is a demo app, not a real test
	rm tests/test-app.lua

	lua run.lua || die
}

src_install() {
	insinto "$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD lua)"
	doins -r lua/pl

	einstalldocs
}
