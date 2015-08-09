# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils toolchain-funcs

MY_P=${PN}_${PV}
DESCRIPTION="polymorphs bytecode to a printable ASCII string"
HOMEPAGE="http://www.phiral.com/research/dissembler.html"
SRC_URI="http://www.phiral.com/research/${MY_P}.tgz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-build.patch
}

src_compile() {
	emake CC="$(tc-getCC)" ${PN} || die
}

src_install() {
	dobin ${PN} || die
	dodoc ${PN}.txt
}
