# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/nullmodem/nullmodem-0.0.6.ebuild,v 1.2 2011/07/21 17:25:40 tomjbe Exp $

EAPI="2"

DESCRIPTION="A Utility to loopback Pseudo-Terminals"
HOMEPAGE="http://www.ant.uni-bremen.de/whomes/rinas/nullmodem/"
SRC_URI="http://www.ant.uni-bremen.de/whomes/rinas/nullmodem/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_install() {
	emake install DESTDIR="${D}" || die
	dodoc ChangeLog README || die
}
