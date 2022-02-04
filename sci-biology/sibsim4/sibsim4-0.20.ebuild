# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="A rewrite and improvement upon sim4, a DNA-mRNA aligner"
HOMEPAGE="http://sibsim4.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/SIBsim4-${PV}.tar.gz"
S="${WORKDIR}/SIBsim4-${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

PATCHES=( "${FILESDIR}"/${P}-makefile.patch )

src_configure() {
	tc-export CC
}

src_install() {
	dobin SIBsim4
	doman SIBsim4.1
}
