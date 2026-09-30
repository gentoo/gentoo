# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="A free Open Source test tool / traffic generator for the SIP protocol"
HOMEPAGE="https://github.com/SIPp/sipp"
SRC_URI="https://github.com/SIPp/sipp/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2 ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gsl +pcap sctp test"

DEPEND="
	dev-libs/openssl:=
	dev-libs/pugixml
	sys-libs/ncurses:=
	gsl? ( sci-libs/gsl:= )
	pcap? (
		net-libs/libpcap
		net-libs/libnet:1.1
	)
	sctp? ( net-misc/lksctp-tools )
	test? ( dev-cpp/gtest )
"
RDEPEND="${DEPEND}"

RESTRICT="!test? ( test )"

src_prepare() {
	sed -e 's/ -Werror / /' -i "${S}/CMakeLists.txt" || die
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DUSE_GSL=$(usex gsl ON OFF)
		-DUSE_PCAP=$(usex pcap ON OFF)
		-DUSE_SCTP=$(usex sctp ON OFF)
		-DUSE_SYSTEM_GTEST=$(usex test ON OFF)
	)

	cmake_src_configure
}

src_compile() {
	cmake_src_compile sipp $(usex test sipp_unittest "")
}

src_install() {
	cmake_src_install

	insinto /usr/share/${PN}
	use pcap && doins pcap/*.pcap
	dodoc CHANGES.md README.md
}
