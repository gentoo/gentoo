# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="A simple TCP benchmark suite"
HOMEPAGE="http://jes.home.cern.ch/jes/gensink/"
SRC_URI="http://jes.home.cern.ch/jes/gensink/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"

PATCHES=(
	"${FILESDIR}/${P}-make.patch"
)

src_compile() {
	tc-export CC
	default
}
src_install() {
	dobin sink4 tub4 gen4
}
