# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-forensics/pasco/pasco-20040505_p1-r1.ebuild,v 1.2 2012/11/25 09:55:48 radhermit Exp $

EAPI=5

inherit toolchain-funcs

MY_P=${PN}_${PV/_p/_}

DESCRIPTION="IE Activity Parser"
HOMEPAGE="http://sourceforge.net/projects/odessa/"
SRC_URI="mirror://sourceforge/odessa/${MY_P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

S="${WORKDIR}/${MY_P}/src"

src_compile() {
	$(tc-getCC) ${CFLAGS} ${LDFLAGS} -o ${PN} ${PN}.c -lm -lc || die "failed to compile"
}

src_install() {
	dobin ${PN}
}
