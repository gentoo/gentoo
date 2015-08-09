# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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
