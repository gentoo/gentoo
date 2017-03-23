# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

DESCRIPTION="A high-level language for Microchip PIC and Ubicom SX microcontrollers"
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
