# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils toolchain-funcs

DESCRIPTION="Motorola's AS11 Assembler for the 68HC11"
HOMEPAGE="http://www.ai.mit.edu/people/rsargent/as11.html"
SRC_URI="http://www.ai.mit.edu/people/rsargent/source/${PN}_src.tar.gz"
LICENSE="freedist"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

S=${WORKDIR}/${PN}

DEPEND=""
RDEPEND=""

src_prepare() {
	epatch "${FILESDIR}"/Makefile.patch
	tc-export CC
}

src_install() {
	dobin ${PN}
	dodoc ${PN}.doc CHANGELOG README
}
