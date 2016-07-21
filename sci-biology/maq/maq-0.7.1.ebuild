# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="Mapping and Assembly with Qualities - mapping Solexa and SOLiD reads to reference sequences"
HOMEPAGE="http://maq.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2
	mirror://sourceforge/${PN}/calib-36.dat.gz"

LICENSE="GPL-3"
SLOT="0"
IUSE=""
KEYWORDS="amd64 x86"

DEPEND=""
RDEPEND=""

src_install() {
	emake DESTDIR="${D}" install || die
	insinto /usr/share/maq
	doins "${WORKDIR}"/*.dat || die
	doman maq.1
	dodoc AUTHORS ChangeLog NEWS maq.pdf
}
