# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="A Kanji code converter"
HOMEPAGE="http://www2s.biglobe.ne.jp/~Nori/ruby/"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"

S="${WORKDIR}/${PN}"
PATCHES=(
	"${FILESDIR}"/${PN}-gcc3-gentoo.diff
	"${FILESDIR}"/${PN}-exit.diff
	"${FILESDIR}"/${PN}-1.0-fix-build-system.patch
)

src_configure() {
	tc-export CC
}

src_install() {
	dobin kcc
	einstalldocs

	cp -f kcc.jman kcc.1 || die
	doman -i18n=ja kcc.1
}
