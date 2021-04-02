# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="A network monitoring tool with bandwidth tracking"
HOMEPAGE="http://www.adaptive-enterprises.com.au/~d/software/pktstat/"
SRC_URI="http://www.adaptive-enterprises.com.au/~d/software/pktstat/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

BDEPEND="virtual/pkgconfig"
RDEPEND="
	net-libs/libpcap
	>=sys-libs/ncurses-5.3-r1
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-tinfo.patch
	"${FILESDIR}"/${P}-smtp_line.patch
)

src_prepare() {
	default

	eautoreconf
}

src_install() {
	dosbin pktstat
	doman pktstat.1
	dodoc ChangeLog NEWS README TODO
}
