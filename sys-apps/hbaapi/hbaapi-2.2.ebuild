# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils toolchain-funcs

MY_PN="${PN}_src"
MY_P="${MY_PN}_${PV}"
DESCRIPTION="The Host Bus Adapter API for managing Fibre Channel Host Bus Adapters"
HOMEPAGE="http://hbaapi.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tgz
	mirror://gentoo/${P}.Makefile.gz"

LICENSE="SNIA"
SLOT="0"
KEYWORDS="~ppc ~x86 ~amd64"
IUSE=""

RESTRICT="test"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	mv "${WORKDIR}"/${P}.Makefile "${S}"/Makefile

	sed -i -e "s/-g -c/${CFLAGS} -c/" \
		-e "s/-shared/\0 ${LDFLAGS}/" \
		Makefile || die

	epatch "${FILESDIR}"/${P}-qa.patch
}

src_compile() {
	# not parallel safe!
	emake -j1 CC="$(tc-getCC)" all
}

src_install() {
	into /usr
	dolib.so libHBAAPI.so
	dosbin hbaapitest
	insinto /etc
	doins "${FILESDIR}"/hba.conf
	dodoc readme.txt
}
