# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Small stealth network autoconfigure software"
HOMEPAGE="http://selfdhcp.sourceforge.net"
SRC_URI="mirror://sourceforge/selfdhcp/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc ~sparc ~x86"

DEPEND="
	dev-libs/popt
	dev-libs/libxml2:2=
	>=net-libs/libnet-1.0.2:1.0
	net-libs/libpcap
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-buffer-overflow.patch"
)

src_install() {
	emake DESTDIR="${ED}" install
	dodoc AUTHORS ChangeLog README TODO
}
