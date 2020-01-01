# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools

DESCRIPTION="Interactive Packet Sniffer"
HOMEPAGE="https://github.com/resurrecting-open-source-projects/sniffit"
SRC_URI="${HOMEPAGE}/archive/${P}.tar.gz"
SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"

RDEPEND="
	net-libs/libpcap
	>=sys-libs/ncurses-5.2
"
DEPEND="
	${RDEPEND}
"
PATCHES=(
	"${FILESDIR}"/${PN}-0.4.0-tinfo.patch
)
S=${WORKDIR}/${PN}-${P}

src_prepare() {
	default
	eautoreconf
}
