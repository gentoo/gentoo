# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/makecif/makecif-5.6.6-r1.ebuild,v 1.4 2013/02/03 17:56:31 ago Exp $

EAPI=4

inherit eutils fortran-2 toolchain-funcs

DESCRIPTION="PDB --> CIF convertor"
HOMEPAGE="http://www.ysbl.york.ac.uk/~alexei/makecif.html"
SRC_URI="mirror://gentoo/${P}.tar.gz"

SLOT="0"
KEYWORDS="~amd64 ppc ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
LICENSE="ccp4"
IUSE=""

S="${WORKDIR}"/${PN}

DEPEND=""
RDEPEND="
	!>=sci-chemistry/refmac-5.6
	sci-libs/monomer-db"

src_prepare() {
	epatch "${FILESDIR}"/${PV}-makefile.patch
}

src_compile() {
	emake -C src clean
	emake \
		-C src \
		BLANC_FORT="$(tc-getFC) ${FFLAGS}" \
		LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin bin/*
	dodoc readme
}
