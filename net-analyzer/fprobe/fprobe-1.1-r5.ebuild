# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="libpcap-based tool to collect network traffic data and emit it as NetFlow flows"
HOMEPAGE="http://fprobe.sourceforge.net"
SRC_URI="mirror://sourceforge/fprobe/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="debug messages"

RDEPEND="net-libs/libpcap"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/fprobe-1.1-pidfile-sanity.patch
	"${FILESDIR}"/fprobe-1.1-setgroups.patch
)

src_configure() {
	econf \
		$(use_enable debug) \
		$(use_enable messages)
}

src_install() {
	default

	docinto contrib
	dodoc contrib/tg.sh

	newinitd "${FILESDIR}"/init.d-fprobe-r1 fprobe
	newconfd "${FILESDIR}"/conf.d-fprobe-r1 fprobe
}
