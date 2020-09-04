# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs

DESCRIPTION="Command line argument parser for the Lua Programming Language"
HOMEPAGE="https://github.com/mpeterv/argparse"
SRC_URI="https://github.com/mpeterv/argparse/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc64"
IUSE="doc luajit test"

RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-lang/lua-5.1:=
	luajit? ( dev-lang/luajit:2 )"
BDEPEND="
	virtual/pkgconfig
	doc? ( dev-python/sphinx )
	test? (
		${RDEPEND}
		dev-lua/busted
	)"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN//lua-/}-${PV}"

src_compile() {
	if use doc; then
		sphinx-build docsrc html || die
		rm -rf "${S}"/html/{.doctrees,_sources} || die
	fi
}

src_test() {
	busted -o gtest --exclude-tags="unsafe" || die
}

src_install() {
	use doc && local -a HTML_DOCS=( html/. )
	local -a DOCS=( README.md CHANGELOG.md )
	einstalldocs

	local instdir
	instdir="$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD $(usex luajit 'luajit' 'lua'))"

	insinto "${instdir#${EPREFIX}}"
	doins src/argparse.lua
}
