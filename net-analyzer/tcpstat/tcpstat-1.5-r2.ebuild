# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils autotools flag-o-matic

DESCRIPTION="Reports network interface statistics"
SRC_URI="https://www.frenchfries.net/paul/tcpstat/${P}.tar.gz"
HOMEPAGE="https://www.frenchfries.net/paul/tcpstat/"

DEPEND="net-libs/libpcap"

SLOT="0"
LICENSE="BSD-2"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="ipv6"

src_prepare() {
	epatch "${FILESDIR}"/${P}-db.patch
	eautoreconf
}

src_configure() {
	append-flags -Wall -Wextra
	econf $(use_enable ipv6)
}

DOCS=( AUTHORS ChangeLog NEWS README doc/Tips_and_Tricks.txt )

src_install() {
	default
	dobin src/{catpcap,packetdump}
	newdoc src/README README.src
}
