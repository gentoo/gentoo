# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit eutils multilib

DESCRIPTION="Data Acquisition library, for packet I/O"
HOMEPAGE="http://www.snort.org/"
SRC_URI="http://www.snort.org/downloads/1339 -> ${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="ipv6 +afpacket +dump +pcap nfq ipq static-libs"

DEPEND="pcap? ( >=net-libs/libpcap-1.0.0 )
		dump? ( >=net-libs/libpcap-1.0.0 )
		nfq? ( dev-libs/libdnet
			>=net-firewall/iptables-1.4.10
			net-libs/libnetfilter_queue )
		ipq? ( dev-libs/libdnet
			>=net-firewall/iptables-1.4.10
			net-libs/libnetfilter_queue )"

RDEPEND="${DEPEND}"

src_configure() {
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

src_install() {
	emake DESTDIR="${D}" install
	dodoc ChangeLog README

	# Remove unneeded .la files
	rm \
		"${D}"usr/$(get_libdir)/daq/*.la \
		"${D}"usr/$(get_libdir)/libdaq*.la \
		"${D}"usr/$(get_libdir)/libsfbpf.la \
		|| die

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
