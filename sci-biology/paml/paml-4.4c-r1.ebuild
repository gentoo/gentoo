# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit toolchain-funcs versionator

MY_P=$(version_format_string '${PN}$1$2')

DESCRIPTION="Phylogenetic Analysis by Maximum Likelihood"
HOMEPAGE="http://abacus.gene.ucl.ac.uk/software/paml.html"
SRC_URI="http://abacus.gene.ucl.ac.uk/software/${PN}${PV}.tar.gz"

LICENSE="free-noncomm"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

S=${WORKDIR}/${MY_P}

src_prepare() {
	# Notice send by mail to prof. Ziheng Yang
	sed -i "s/\$(CC)/& \$(LDFLAGS)/" src/Makefile || die #335608
}

src_compile() {
	emake -C src \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS} -Wno-unused-result" \
		LDFLAGS="${LDFLAGS}"
}

src_install() {
	dodoc README.txt doc/*

	insinto /usr/share/${PN}/control
	doins *.ctl

	insinto /usr/share/${PN}/dat
	doins stewart* *.dat dat/*

	insinto /usr/share/${PN}
	doins -r examples/

	cd src || die
	dobin baseml codeml basemlg mcmctree pamp evolver yn00 chi2
}
