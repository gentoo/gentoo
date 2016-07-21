# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

KEYWORDS="~amd64 ~x86"

DESCRIPTION="Cute PHP Library (cphplib)"
HOMEPAGE="http://cphplib.sourceforge.net/"
SRC_URI="mirror://sourceforge/cphplib/${P}.tar.bz2"
LICENSE="LGPL-2.1"
SLOT="0"
IUSE=""

DEPEND=">=dev-php/PEAR-DB-1.7.6-r1"
RDEPEND="${DEPEND}"

src_install() {
	insinto "/usr/share/php/${PN}"
	doins *.spec *.inc

	dodoc ChangeLog COPYRIGHT LGPL README TODO
}
