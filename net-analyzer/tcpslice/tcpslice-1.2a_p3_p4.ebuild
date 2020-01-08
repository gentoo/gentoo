# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools flag-o-matic

MY_P="${PN}_$(ver_cut 1).$(ver_cut 2-3)$(ver_cut 5)"

DESCRIPTION="Extract and concatenate portions of pcap files"
HOMEPAGE="http://www.tcpdump.org/ https://github.com/the-tcpdump-group/tcpslice"
LICENSE="BSD"
SLOT="0"
SRC_URI="
	mirror://debian/pool/main/${PN:0:1}/${PN}/${MY_P}.orig.tar.gz
	mirror://debian/pool/main/${PN:0:1}/${PN}/${MY_P}-$(ver_cut 7).debian.tar.gz
"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="
	net-libs/libpcap
"
DEPEND="
	${RDEPEND}
"
S=${WORKDIR}/${MY_P/_/-}

src_prepare() {
	eapply \
		"${WORKDIR}"/debian/patches/[0-]* \
		"${FILESDIR}"/${PN}-1.2a_p3-exit.patch
	eapply_user
	sed -i -e 's|ifndef lint|if 0|g' *.c || die
	eautoconf
}

src_install() {
	dosbin tcpslice
	doman tcpslice.1
	dodoc README
}
