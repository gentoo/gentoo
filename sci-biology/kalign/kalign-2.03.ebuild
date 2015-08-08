# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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
