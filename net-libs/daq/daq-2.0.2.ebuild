# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/daq/daq-2.0.2.ebuild,v 1.3 2014/07/18 14:40:40 jer Exp $

EAPI=5
inherit eutils multilib autotools

DESCRIPTION="Data Acquisition library, for packet I/O"
HOMEPAGE="http://www.snort.org/"
SRC_URI="http://www.snort.org/downloads/2778 -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="ipv6 +afpacket +dump +pcap nfq ipq static-libs"

PCAP_DEPEND=">=net-libs/libpcap-1.0.0"
IPT_DEPEND="
	>=net-firewall/iptables-1.4.10
	dev-libs/libdnet
	net-libs/libnetfilter_queue

"
DEPEND="
	dump? ( ${PCAP_DEPEND} )
	ipq? ( ${IPT_DEPEND} )
	nfq? ( ${IPT_DEPEND} )
	pcap? ( ${PCAP_DEPEND} )
"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-parallel-grammar.patch #511892
	epatch "${FILESDIR}"/${P}-libpcap-check.patch
	eautoreconf
}

src_configure() {
	# We forced libpcap to 1.x, so we can set this cache var so
	# cross-compiling doesn't break on us.
	daq_cv_libpcap_version_1x=yes \
	econf \
		$(use_enable ipv6) \
		$(use_enable pcap pcap-module) \
		$(use_enable afpacket afpacket-module) \
		$(use_enable dump dump-module) \
		$(use_enable nfq nfq-module) \
		$(use_enable ipq ipq-module) \
		$(use_enable static-libs static) \
		--disable-ipfw-module \
		--disable-bundled-modules
}

DOCS=( ChangeLog README )

src_install() {
	default

	prune_libtool_files

	# If not using static-libs don't install the static libraries
	# This has been bugged upstream
	if ! use static-libs; then
		for z in libdaq_static libdaq_static_modules; do
			rm "${D}"usr/$(get_libdir)/${z}.a
		done
	fi
}

pkg_postinst() {
	einfo "The Data Acquisition library (DAQ) for packet I/O replaces direct"
	einfo "calls to PCAP functions with an abstraction layer that facilitates"
	einfo "operation on a variety of hardware and software interfaces without"
	einfo "requiring changes to application such as Snort."
	einfo
	einfo "Please see the README file for DAQ for information about specific"
	einfo "DAQ modules."
}
