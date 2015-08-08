# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit autotools eutils

DESCRIPTION="command-line utility for filesystem quotas"
HOMEPAGE="http://quotatool.ekenberg.se/"
SRC_URI="http://quotatool.ekenberg.se/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="sys-fs/quota"

src_prepare() {
	epatch "${FILESDIR}/${PN}-1.4.11-ldflags.patch"

	# rebuild autotools since it uses symlinked copies of support files
	# that we can't rely on.
	eautoreconf
}

src_install () {
	dobin quotatool
	doman man/quotatool.8
	dodoc AUTHORS ChangeLog README TODO
}
