# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/ta-lib/ta-lib-0.4.0.ebuild,v 1.7 2012/04/26 15:09:46 jlec Exp $

EAPI=4

AUTOTOOLS_AUTORECONF=yes

inherit autotools-utils

DESCRIPTION="Technical Analysis Library for analyzing financial markets trends"
HOMEPAGE="http://www.ta-lib.org/"
SRC_URI="mirror://sourceforge/ta-lib/${P}-src.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

S="${WORKDIR}"/${PN}

PATCHES=( "${FILESDIR}"/${P}-asneeded.patch )

AUTOTOOLS_IN_SOURCE_BUILD=1

src_test() {
	ewarn "Note: this testsuite will fail without an active internet connection."
	"${S}"/src/tools/ta_regtest/ta_regtest || die "Failed testsuite."
}
