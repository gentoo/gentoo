# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="libpcap-based tool to collect network traffic data and emit it as NetFlow flows"
HOMEPAGE="http://fprobe.sourceforge.net"
LICENSE="GPL-2"

SRC_URI="mirror://sourceforge/fprobe/${P}.tar.bz2"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"

IUSE="debug messages"

DEPEND="
	net-libs/libpcap
"
RDEPEND="
	${DEPEND}
"
PATCHES=(
	"${FILESDIR}"/fprobe-1.1-pidfile-sanity.patch
	"${FILESDIR}"/fprobe-1.1-setgroups.patch
)

src_configure() {
	econf \
		$(use_enable debug) \
		$(use_enable messages)
}

DOCS=( AUTHORS NEWS README TODO )

src_install() {
	default

	docinto contrib
	dodoc contrib/tg.sh

	newinitd "${FILESDIR}"/init.d-fprobe fprobe
	newconfd "${FILESDIR}"/conf.d-fprobe fprobe
}
