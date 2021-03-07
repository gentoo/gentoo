# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="IAX (Inter Asterisk eXchange) Library"
HOMEPAGE="https://www.asterisk.org/"
SRC_URI="https://downloads.asterisk.org/pub/telephony/libiax/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc x86"
IUSE="debug snomhack"

PATCHES=(
	"${FILESDIR}/${PV}-debug.patch"
	"${FILESDIR}/${PV}-memset.patch"
	"${FILESDIR}/${PV}-sandbox.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable debug extreme-debug) \
		$(use_enable snomhack)
}
