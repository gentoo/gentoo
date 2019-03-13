# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=0

IUSE="berkdb"

DESCRIPTION="Reports network interface statistics"
SRC_URI="https://www.frenchfries.net/paul/tcpstat/${P}.tar.gz"
HOMEPAGE="https://www.frenchfries.net/paul/tcpstat/"

DEPEND="net-libs/libpcap
	berkdb? ( <sys-libs/db-2 )"

SLOT="0"
LICENSE="BSD-2"
KEYWORDS="amd64 ~ppc ppc64 sparc x86"

src_install () {

	make DESTDIR=${D} install || die
	use berkdb && dobin src/tcpprof

	dodoc AUTHORS ChangeLog COPYING LICENSE NEWS README*

}
