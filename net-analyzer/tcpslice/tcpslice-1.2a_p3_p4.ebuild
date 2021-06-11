# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

MY_P="${PN}_$(ver_cut 1).$(ver_cut 2-3)$(ver_cut 5)"

DESCRIPTION="Extract and concatenate portions of pcap files"
HOMEPAGE="http://www.tcpdump.org/ https://github.com/the-tcpdump-group/tcpslice"
SRC_URI="
	mirror://debian/pool/main/${PN:0:1}/${PN}/${MY_P}.orig.tar.gz
	mirror://debian/pool/main/${PN:0:1}/${PN}/${MY_P}-$(ver_cut 7).debian.tar.gz
"
S="${WORKDIR}"/${MY_P/_/-}

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"

RDEPEND="net-libs/libpcap"
DEPEND="${RDEPEND}"

src_prepare() {
	eapply "${WORKDIR}"/debian/patches/[0-]*
	eapply "${FILESDIR}"/${PN}-1.2a_p3-exit.patch

	default

	sed -i -e 's|ifndef lint|if 0|g' *.c || die

	mv configure.{in,ac} || die
	eautoreconf
}

src_install() {
	dosbin tcpslice
	doman tcpslice.1
	dodoc README
}
