# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit eutils

DESCRIPTION="Automated de novo identification of repeat families from genomic sequences"
HOMEPAGE="http://selab.janelia.org/recon.html http://www.repeatmasker.org/RepeatModeler.html"
SRC_URI="http://www.repeatmasker.org/RECON${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE="examples"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/RECON${PV}"

src_prepare() {
	epatch "${FILESDIR}"/${PV}-buffer-overflow.patch
	sed -i 's|$path = "";|$path = "/usr/libexec/'${PN}'";|' scripts/recon.pl || die
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
