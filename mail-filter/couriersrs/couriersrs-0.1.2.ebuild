# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="SRS (Sender Rewriting Scheme) wrapper for the courier MTA"
HOMEPAGE="http://couriersrs.com/"
SRC_URI="http://couriersrs.com/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

DEPEND="dev-libs/popt
	mail-filter/libsrs2"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${P}-automake-fixes.diff" )

src_prepare() {
	default
	rm m4/*.m4 || die "rm failed!"
	AT_M4DIR="m4" eautoreconf
}
