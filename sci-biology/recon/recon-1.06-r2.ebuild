# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/recon/recon-1.06-r2.ebuild,v 1.1 2012/08/26 13:01:44 jlec Exp $

EAPI="4"

inherit eutils toolchain-funcs

DESCRIPTION="Automated de novo identification of repeat families from genomic sequences"
HOMEPAGE="http://selab.janelia.org/recon.html http://www.repeatmasker.org/RepeatModeler.html"
SRC_URI="http://www.repeatmasker.org/RECON${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE="examples"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/RECON${PV}"

src_prepare() {
	epatch \
		"${FILESDIR}"/${PV}-buffer-overflow.patch \
		"${FILESDIR}"/${P}-respect.patch
	sed -i 's|$path = "";|$path = "/usr/libexec/'${PN}'";|' scripts/recon.pl || die
	tc-export CC
}

src_compile() {
	emake -C src
}

src_install() {
	dobin scripts/*
	exeinto /usr/libexec/${PN}
	doexe src/{edgeredef,eledef,eleredef,famdef,imagespread}
	dodoc 00README
	insinto /usr/share/${PN}
	use examples && doins -r Demos
}
