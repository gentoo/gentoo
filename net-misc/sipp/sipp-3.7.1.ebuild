# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="A free Open Source test tool / traffic generator for the SIP protocol"
HOMEPAGE="http://sipp.sourceforge.net/ https://github.com/SIPp/sipp/releases"
SRC_URI="https://github.com/SIPp/sipp/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2 ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gsl +pcap sctp +ssl"

DEPEND="sys-libs/ncurses:=
	gsl? ( sci-libs/gsl:= )
	pcap? (
		net-libs/libpcap
		net-libs/libnet:1.1
	)
	sctp? ( net-misc/lksctp-tools )
	ssl? ( dev-libs/openssl:= )
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DUSE_GSL=$(usex gsl 1 0)
		-DUSE_PCAP=$(usex pcap 1 0)
		-DUSE_SCTP=$(usex sctp 1 0)
		-DUSE_SSL=$(usex ssl 1 0)
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	insinto /usr/share/${PN}
	use pcap && doins pcap/*.pcap
	dodoc CHANGES.md README.md
}
