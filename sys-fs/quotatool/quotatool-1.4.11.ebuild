# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

inherit autotools eutils

DESCRIPTION="command-line utility for filesystem quotas"
HOMEPAGE="http://quotatool.ekenberg.se/"
SRC_URI="http://quotatool.ekenberg.se/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="sys-fs/quota"
DEPEND=""

src_prepare() {
	epatch "${FILESDIR}/${P}-ldflags.patch"

	# rebuild autotools since it uses symlinked copies of support files
	# that we can't rely on.
	eautoreconf
}

src_install () {
	dobin quotatool || die
	doman man/quotatool.8 || die
	dodoc AUTHORS ChangeLog README TODO || die
}
