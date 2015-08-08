# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="TCP proxy for applications that don't speak IPv6"
HOMEPAGE="http://toxygen.net/6tunnel"
SRC_URI="http://toxygen.net/6tunnel/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="s390 x86"
IUSE=""

DEPEND=""

src_install() {
	dobin 6tunnel || die
	doman 6tunnel.1
}
