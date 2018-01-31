# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools

DESCRIPTION="NAST - Network Analyzer Sniffer Tool"
HOMEPAGE="https://sourceforge.net/projects/nast.berlios/"
SRC_URI="mirror://sourceforge/${PN}.berlios/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="ncurses"

RDEPEND="
	>=net-libs/libnet-1.1.1
	net-libs/libpcap
	ncurses? ( >=sys-libs/ncurses-5.4:= )
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"
PATCHES=(
	"${FILESDIR}"/${P}-gentoo.patch
)

src_prepare() {
	default
	eautoreconf
}

src_compile() {
	emake CFLAGS="${CFLAGS}"
}

src_install() {
	dosbin nast
	doman nast.8
	dodoc AUTHORS BUGS CREDITS ChangeLog NCURSES_README README TODO
}
