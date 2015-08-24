# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils

DESCRIPTION="a periodic ping program"
HOMEPAGE="https://www.gnu.org/software/alive/"
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
