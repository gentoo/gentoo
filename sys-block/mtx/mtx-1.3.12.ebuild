# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=0

DESCRIPTION="Utilities for controlling SCSI media changers and tape drives"
HOMEPAGE="https://sourceforge.net/projects/mtx/"
SRC_URI="mirror://sourceforge/mtx/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ppc ppc64 sparc x86"
IUSE=""

src_install () {
	einstall || die
	dodoc CHANGES COMPATABILITY FAQ README TODO
	dohtml mtxl.README.html
}
