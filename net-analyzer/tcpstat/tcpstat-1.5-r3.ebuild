# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools flag-o-matic

DESCRIPTION="Reports network interface statistics"
HOMEPAGE="https://www.frenchfries.net/paul/tcpstat/"
SRC_URI="${HOMEPAGE}${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ppc64 sparc x86"
IUSE="ipv6"

DEPEND="
	net-libs/libpcap
"
RDEPEND="
	${DEPEND}
"
DOCS=( AUTHORS ChangeLog NEWS README doc/Tips_and_Tricks.txt )
PATCHES=(
	"${FILESDIR}"/${P}-db.patch
	"${FILESDIR}"/${P}-_DEFAULT_SOURCE.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	append-cflags -Wall -Wextra
	econf \
		$(use_enable ipv6) \
		--with-pcap-include='' \
		--with-pcap-lib="$( $(tc-getPKG_CONFIG) --libs libpcap)"
}

src_install() {
	default
	dobin src/{catpcap,packetdump}
	newdoc src/README README.src
}
