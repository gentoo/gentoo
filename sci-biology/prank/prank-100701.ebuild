# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/prank/prank-100701.ebuild,v 1.4 2015/03/29 13:52:32 jlec Exp $

EAPI=4

inherit toolchain-funcs

DESCRIPTION="Probabilistic Alignment Kit"
HOMEPAGE="http://wasabiapp.org/software/prank/"
SRC_URI="http://www.ebi.ac.uk/goldman-srv/prank/src/prank/prank.src.${PV}.tgz"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

S=${WORKDIR}/${PN}

src_prepare() {
	sed -i -e "s/\$(LINK)/& \$(LDFLAGS)/" Makefile || die
}

src_compile() {
	emake \
		LINK="$(tc-getCXX)" \
		CXX="$(tc-getCXX)" \
		CFLAGS="${CFLAGS}" \
		CXXFLAGS="${CXXFLAGS}"
}

src_install() {
	dobin prank
}
