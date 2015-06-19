# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-firewall/dshieldpy/dshieldpy-3.2-r1.ebuild,v 1.3 2012/02/24 15:24:31 phajdan.jr Exp $

EAPI="4"
PYTHON_DEPEND="2"
inherit python

DESCRIPTION="Python script to submit firewall logs to dshield.org"
HOMEPAGE="http://dshieldpy.sourceforge.net/"
SRC_URI="mirror://sourceforge/dshieldpy/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""
DEPEND=""
RDEPEND=""
S=${WORKDIR}/DShield.py

src_install() {
	dodoc CHANGELOG README*
	dobin dshield.py

	insinto /etc
	doins dshieldpy.conf
	python_convert_shebangs 2 "${ED}"usr/bin/dshield.py
}
