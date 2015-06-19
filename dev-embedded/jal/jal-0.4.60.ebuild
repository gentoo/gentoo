# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-embedded/jal/jal-0.4.60.ebuild,v 1.4 2014/08/10 20:03:49 slyfox Exp $

DESCRIPTION="A high-level language for a number of Microchip PIC and Ubicom SX microcontrollers"
HOMEPAGE="http://jal.sourceforge.net/"
SRC_URI="mirror://sourceforge/jal/${P}.tar.gz"
LICENSE="GPL-2"
KEYWORDS="x86"
SLOT="0"
IUSE=""
DEPEND=""

src_install() {
	make DESTDIR=${D} install || die
}
