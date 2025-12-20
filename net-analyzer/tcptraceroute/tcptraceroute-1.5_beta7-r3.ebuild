# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools

DESCRIPTION="tcptraceroute is a traceroute implementation using TCP packets"
HOMEPAGE="https://github.com/mct/tcptraceroute"
SRC_URI="https://github.com/mct/${PN}/archive/${P/_}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~loong ppc ppc64 ~riscv ~sparc x86"

DEPEND="
	net-libs/libnet:1.1
	net-libs/libpcap
"
RDEPEND="${DEPEND}"
RESTRICT="test"
PATCHES=(
	"${FILESDIR}"/${P}-cross-compile-checks.patch
)
S=${WORKDIR}/${PN}-${P/_}

src_prepare() {
	default
	eautoreconf
}

src_install() {
	dosbin tcptraceroute
	fowners root:wheel /usr/sbin/tcptraceroute
	fperms 4710 /usr/sbin/tcptraceroute
	doman tcptraceroute.1
	dodoc examples.txt README ChangeLog
	docinto html
	dodoc tcptraceroute.1.html
}
