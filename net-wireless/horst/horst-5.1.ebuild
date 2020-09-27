# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit toolchain-funcs vcs-snapshot

DESCRIPTION="Small 802.11 wireless LAN analyzer"
HOMEPAGE="https://github.com/br101/horst/"
SRC_URI="https://github.com/br101/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug +pcap test"

RDEPEND="
	dev-libs/libnl:3
	sys-libs/ncurses:0
	pcap? ( net-libs/libpcap )
"
TDEPEND="
	test? ( sys-devel/sparse )
"
DEPEND="
	${RDEPEND}
	${TDEPEND}
	virtual/pkgconfig
"
RESTRICT=test #just semantic tests, no functional tests
PATCHES=(
	"${FILESDIR}"/${PN}-5.1-CC.patch
	"${FILESDIR}"/${PN}-5.1-pcap_bufsize.patch
	"${FILESDIR}"/${PN}-5.1-tinfo.patch
)

src_compile() {
	tc-export CC PKG_CONFIG
	emake PCAP=$(usex pcap 1 0) DEBUG=$(usex debug 1 0)
}

src_install() {
	dosbin ${PN}{,.sh}
	dodoc README.md
	doman ${PN}.8
}
