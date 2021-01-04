# Copyright 1999-2021 Gentoo Authors
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

DEPEND=">=dev-lang/lua-5.1:0="

RDEPEND="
	dev-lua/luafilesystem
	${DEPEND}
"

BDEPEND="
	virtual/pkgconfig
	test? ( ${DEPEND} )
"

HTML_DOCS=( "docs/." )

src_prepare() {
	default

	# This is a demo app, not a real test
	rm tests/test-app.lua || die

	# Remove test for executing a non-existent command
	sed -e '/most-likely-nonexistent-command/d' -i tests/test-utils3.lua || die
}

src_test() {
	lua run.lua || die
}

src_install() {
	insinto "$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD lua)"
	doins -r lua/pl

	einstalldocs
}
