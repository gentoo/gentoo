# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
MY_P="${P}-ipv6"

inherit autotools

DESCRIPTION="Testing of network intrusion detection systems, firewalls and TCP/IP stacks"
HOMEPAGE="https://github.com/stsi/fragroute-ipv6"
SRC_URI="https://fragroute-ipv6.googlecode.com/files/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86"

RDEPEND="
	>=dev-libs/libdnet-1.14-r1
	dev-libs/libevent:=
	net-libs/libpcap
	dev-libs/libbsd

"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	app-alternatives/awk
"
DOCS=( INSTALL README TODO )
PATCHES=(
	"${FILESDIR}"/${P}-libdir.patch
	"${FILESDIR}"/${P}-pcap_open.patch
	"${FILESDIR}"/${P}-missing-includes.patch
)

src_prepare() {
	default

	# Remove broken and old files, autotools will regen needed files
	rm *.m4 acconfig.h missing Makefile.in || die

	eautoreconf
}

src_configure() {
	econf \
		DNETINC='' \
		DNETLIB=-ldnet \
		EVENTINC='' \
		EVENTLIB=-levent \
		PCAPINC='' \
		PCAPLIB=-lpcap
}
