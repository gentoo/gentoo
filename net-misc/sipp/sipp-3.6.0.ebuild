# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="A free Open Source test tool / traffic generator for the SIP protocol"
HOMEPAGE="http://sipp.sourceforge.net/ https://github.com/SIPp/sipp/releases"
SRC_URI="https://github.com/SIPp/sipp/releases/download/v${PV}/${PF}.tar.gz"

LICENSE="GPL-2 ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gsl +pcap sctp +ssl"

PATCHES=( "${FILESDIR}/sipp-3.6.0-parallel-build.patch" )

DEPEND="sys-libs/ncurses:=
	gsl? ( sci-libs/gsl:= )
	pcap? (
		net-libs/libpcap
		net-libs/libnet:1.1
	)
	ssl? ( dev-libs/openssl:= )
"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_with gsl) \
		$(use_with pcap) \
		$(use_with sctp) \
		$(use_with ssl openssl) \
		--with-rtpstream
}

src_install() {
	default
	insinto /usr/share/${PN}
	use pcap && doins pcap/*.pcap
	dodoc CHANGES.md README.md
}
