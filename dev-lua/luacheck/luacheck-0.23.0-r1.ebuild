# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs

DESCRIPTION="A tool for linting and static analysis of Lua code"
HOMEPAGE="https://github.com/mpeterv/luacheck"
SRC_URI="https://github.com/mpeterv/luacheck/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 ppc ppc64 ~x86"
IUSE="doc luajit test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-lua/lua-argparse[luajit(-)=]
	dev-lua/luafilesystem[luajit(-)=]
	dev-lua/lua-utf8[luajit(-)=]
	!luajit? ( >=dev-lang/lua-5.1:0= )
	luajit? ( dev-lang/luajit:2 )"
BDEPEND="
	virtual/pkgconfig
	doc? ( dev-python/sphinx )
	test? (
		${RDEPEND}
		dev-lua/busted
	)"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}/${PN}-0.23.0-disable-measuring-performance-test.patch" )

src_compile() {
	if use doc; then
		sphinx-build docsrc html || die
	fi
}

src_test() {
	busted -o gtest || die
}

src_install() {
	local instdir
	instdir="$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD $(usex luajit 'luajit' 'lua'))"
	insinto "${instdir#${EPREFIX}}"
	doins -r src/luacheck

	newbin bin/luacheck.lua luacheck

	use doc && local HTML_DOCS=( html/. )

	local -a DOCS=( CHANGELOG.md LICENSE README.md )
	einstalldocs
}
