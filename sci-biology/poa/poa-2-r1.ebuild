# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

MY_P="${PN}V${PV}"

DESCRIPTION="Fast multiple sequence alignments using partial-order graphs"
HOMEPAGE="http://bioinfo.mbi.ucla.edu/poa/"
SRC_URI="mirror://sourceforge/poamsa/${MY_P}.tar.gz"

# According to SF project page
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}"/${P}-respect-flags.patch
	"${FILESDIR}"/${P}-fno-common.patch
	"${FILESDIR}"/${P}-clang16.patch
)

src_configure() {
	tc-export AR CC RANLIB
}

src_compile() {
	emake poa
}

src_install() {
	dobin poa make_pscores.pl
	dodoc README multidom.*
	insinto /usr/share/poa
	doins *.mat
}

pkg_postinst() {
	elog "poa requires a score matrix as the first argument."
	elog "This package installs two examples to ${EROOT}/usr/share/poa/."
}
