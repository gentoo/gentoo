# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/mktorrent/mktorrent-1.0-r1.ebuild,v 1.4 2015/05/23 13:52:45 pacho Exp $

EAPI=5
inherit toolchain-funcs

DESCRIPTION="Simple command line utility to create BitTorrent metainfo files"
HOMEPAGE="http://mktorrent.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="threads +ssl debug"

RDEPEND="ssl? ( dev-libs/openssl:0 )"
DEPEND="${RDEPEND}"

src_compile() {
	tc-export CC
	MAKEPARAM="USE_LONG_OPTIONS=1"
	MAKEPARAM="${MAKEPARAM} USE_LARGE_FILES=1"
	use debug && MAKEPARAM="${MAKEPARAM} DEBUG=1"
	use ssl && MAKEPARAM="${MAKEPARAM} USE_OPENSSL=1"
	use threads && MAKEPARAM="${MAKEPARAM} USE_PTHREADS=1"

	emake ${MAKEPARAM}
}

src_install() {
	dobin ${PN}
	dodoc README
}
