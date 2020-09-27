# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit git-r3 toolchain-funcs

DESCRIPTION="Small 802.11 wireless LAN analyzer"
HOMEPAGE="https://github.com/br101/horst/"
EGIT_REPO_URI="https://github.com/br101/${PN}/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
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
	"${FILESDIR}"/${PN}-9999-tinfo.patch
)

src_compile() {
	tc-export CC PKG_CONFIG
	emake PCAP=$(usex pcap 1 0) DEBUG=$(usex debug 1 0)
}

src_install() {
	dosbin ${PN}{,.sh}
	dodoc README.md
	doman ${PN}.8
	insinto /etc
	doins ${PN}.conf
}
