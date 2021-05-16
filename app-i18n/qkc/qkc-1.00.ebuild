# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

MY_P="${PN}c${PV/./}"

DESCRIPTION="Quick KANJI code Converter"
HOMEPAGE="http://hp.vector.co.jp/authors/VA000501/"
SRC_URI="http://hp.vector.co.jp/authors/VA000501/${MY_P}.zip"

LICENSE="freedist"
SLOT="0"
KEYWORDS="~alpha amd64 ppc ppc64 sparc x86"

BDEPEND="app-arch/unzip"

S="${WORKDIR}"

PATCHES=( "${FILESDIR}"/${P}-makefile.patch )

src_configure() {
	tc-export CC
}

src_install() {
	dobin qkc
	dodoc qkc.doc
	doman -i18n=ja qkc.1
}
