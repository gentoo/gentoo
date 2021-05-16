# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Phylogenetic Analysis by Maximum Likelihood"
HOMEPAGE="http://abacus.gene.ucl.ac.uk/software/paml.html"
SRC_URI="http://abacus.gene.ucl.ac.uk/software/${P/-/}.tgz"

LICENSE="free-noncomm"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/${P/-/}"
PATCHES=(
	"${FILESDIR}"/${PN}-4.9j-makefile.patch
	"${FILESDIR}"/${PN}-4.9j-fno-common.patch
)

src_configure() {
	tc-export CC
}

src_compile() {
	emake -C src
}

src_install() {
	dobin src/{baseml,basemlg,codeml,evolver,pamp,mcmctree,infinitesites,yn00,chi2}

	dodoc -r README.txt doc/.

	insinto /usr/share/${PN}/control
	doins *.ctl

	insinto /usr/share/${PN}/dat
	doins -r stewart* *.dat dat/.

	insinto /usr/share/${PN}
	doins -r examples
}
