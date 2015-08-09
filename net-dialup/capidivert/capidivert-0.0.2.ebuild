# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="CAPI based utility to control ISDN diversion facilities"
HOMEPAGE="http://www.tp1.ruhr-uni-bochum.de/~kai/i4l/capidivert/"
SRC_URI="http://www.tp1.ruhr-uni-bochum.de/~kai/i4l/capidivert/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="net-dialup/capi4k-utils"
RDEPEND="${DEPEND}"

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
}
