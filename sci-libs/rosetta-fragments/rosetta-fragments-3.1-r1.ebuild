# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils flag-o-matic prefix toolchain-funcs

DESCRIPTION="Fragment library for rosetta"
HOMEPAGE="http://www.rosettacommons.org"
SRC_URI="rosetta3.1_fragments.tgz"

LICENSE="rosetta"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND=""
RDEPEND="
	sci-biology/ncbi-tools
	|| ( sci-biology/update-blastdb sci-biology/ncbi-tools++ )
	sci-biology/psipred"

RESTRICT="fetch"

S="${WORKDIR}"/${PN/-/_}

pkg_nofetch() {
	einfo "Go to ${HOMEPAGE} and get ${PN}.tgz and rename it to ${A}"
	einfo "which must be placed in ${DISTDIR}"
}

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-nnmake.patch \
		"${FILESDIR}"/${P}-chemshift.patch
	tc-export F77
	eprefixify nnmake/*.pl
}

src_compile() {
	emake -C nnmake
	emake -C chemshift
}

src_install() {
	esvn_clean .

	newbin nnmake/pNNMAKE.gnu pNNMAKE
	newbin chemshift/pCHEMSHIFT.gnu pCHEMSHIFT

	dobin nnmake/*.pl

	insinto /usr/share/${PN}
	doins -r *_database
	dodoc fragments.README nnmake/{nnmake.README,vall/*.pl} chemshift/chemshift.README
}
