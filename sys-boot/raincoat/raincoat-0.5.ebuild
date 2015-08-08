# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="Flash the Xbox boot chip"
HOMEPAGE="http://www.xbox-linux.org/"
SRC_URI="http://xbox-linux.org/down/raincoat-0.5+.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""
DEPEND=""

S=${WORKDIR}/${PN}

src_compile() {
	emake || die
}

src_install() {
	dodir /etc
	insinto /etc
	doins raincoat.conf
	dobin raincoat || die
	dodoc README
}
