# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/kalign/kalign-2.03.ebuild,v 1.3 2009/03/21 17:10:35 armin76 Exp $

DESCRIPTION="Global and progressive multiple sequence alignment"
HOMEPAGE="http://msa.cgb.ki.se/"
SRC_URI="mirror://debian/pool/main/k/kalign/${PN}_${PV}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="amd64 x86"

DEPEND=""
RDEPEND=""

S="${WORKDIR}/${PN}"

src_unpack() {
	unpack ${A}
	sed -i 's/^CFLAGS.*= -O9/CFLAGS := ${CFLAGS} -O3/' "${S}"/Makefile.in
}

src_install() {
	dobin kalign
	dodoc README
}
