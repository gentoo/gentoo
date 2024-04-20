# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Kanji code converter"
HOMEPAGE="http://www2s.biglobe.ne.jp/~Nori/ruby/"
SRC_URI="mirror://gentoo/${P}.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 x86"

PATCHES=(
	"${FILESDIR}"/${PN}-gcc3-gentoo.diff
	"${FILESDIR}"/${PN}-exit.diff
	"${FILESDIR}"/${P}-fix-build-system.patch
	"${FILESDIR}"/${P}-clang16.patch
)

src_configure() {
	tc-export CC
	append-cflags -std=gnu89 # old codebase, incompatible with c2x
}

src_install() {
	dobin kcc
	einstalldocs

	cp kcc.jman kcc.1 || die
	doman -i18n=ja kcc.1
}
