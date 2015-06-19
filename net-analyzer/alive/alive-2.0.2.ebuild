# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/alive/alive-2.0.2.ebuild,v 1.2 2014/06/24 02:30:03 jer Exp $

EAPI=5
inherit autotools eutils

DESCRIPTION="a periodic ping program"
HOMEPAGE="http://www.gnu.org/software/alive/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~x86"
IUSE=""

COMMON_DEPEND="net-misc/iputils"
DEPEND="
	app-arch/xz-utils
	${COMMON_DEPEND}
"
RDEPEND="
	dev-scheme/guile
	${COMMON_DEPEND}
"

src_prepare() {
	epatch "${FILESDIR}"/${P}-ping-test.patch
	eautoreconf
}
