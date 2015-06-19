# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/6tunnel/6tunnel-0.10.ebuild,v 1.4 2006/11/27 00:07:29 vapier Exp $

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
