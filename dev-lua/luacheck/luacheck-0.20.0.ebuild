# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit toolchain-funcs

DESCRIPTION="A tool for linting and static analysis of Lua code"
HOMEPAGE="https://github.com/mpeterv/luacheck"
SRC_URI="https://github.com/mpeterv/luacheck/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc luajit test"

RDEPEND="
	dev-lua/luafilesystem[luajit=]
	!luajit? ( >=dev-lang/lua-5.1:= )
	luajit? ( dev-lang/luajit:2 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( dev-python/sphinx )
	test? ( dev-lua/busted )"

DOCS=( CHANGELOG.md README.md )

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

	use doc && HTML_DOCS+=( html/. )

	einstalldocs
}
