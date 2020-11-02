# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
MY_P="${P}-ipv6"
inherit autotools

DESCRIPTION="Testing of network intrusion detection systems, firewalls and TCP/IP stacks"
HOMEPAGE="https://github.com/stsi/fragroute-ipv6"
SRC_URI="https://fragroute-ipv6.googlecode.com/files/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86"

RDEPEND="
	>=dev-libs/libdnet-1.14-r1
	dev-libs/libevent:=
	net-libs/libpcap
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	virtual/awk
"
DOCS=( INSTALL README TODO )
PATCHES=(
	"${FILESDIR}"/${P}-libdir.patch
	"${FILESDIR}"/${P}-pcap_open.patch
)
S="${WORKDIR}/${MY_P}"

src_prepare() {
	default

	# Remove broken and old files, autotools will regen needed files
	rm *.m4 acconfig.h missing Makefile.in || die

	# Add missing includes
	sed -i -e "/#define IPUTIL_H/a#include <stdio.h>\n#include <stdint.h>" iputil.h || die

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
