# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools eutils

DESCRIPTION="A TCP, UDP, and SCTP network bandwidth measurement tool"
HOMEPAGE="https://github.com/esnet/iperf/"
SRC_URI="${HOMEPAGE}archive/${PV/_/}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="3"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint"
IUSE="libressl profiling sctp static-libs"

DEPEND="
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	sctp? ( net-misc/lksctp-tools )
"
RDEPEND="${DEPEND}"
S=${WORKDIR}/${P/_/}

src_configure() {
	use sctp || export ac_cv_header_netinet_sctp_h=no
	econf \
		$(use_enable profiling) \
		$(use_enable static-libs static)
}

src_install() {
	default
	newconfd "${FILESDIR}"/iperf.confd iperf3
	newinitd "${FILESDIR}"/iperf3.initd iperf3
	prune_libtool_files
}
