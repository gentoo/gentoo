# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A virtual machine simulator based on a MIPS R3000 processor"
HOMEPAGE="http://vmips.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc"
IUSE=""

DEPEND="app-emulation/vmips-cross-bin"
