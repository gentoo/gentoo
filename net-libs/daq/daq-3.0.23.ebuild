# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="libdaq"
MY_P="${MY_PN}-${PV}"

inherit autotools

DESCRIPTION="Data Acquisition library, for packet I/O"
HOMEPAGE="https://github.com/snort3"
SRC_URI="https://github.com/snort3/${MY_PN}/archive/refs/tags/v${PV}.tar.gz -> ${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="+afpacket bpf +dump fst nfq +pcap savefile trace gwlb static-libs test"
RESTRICT="!test? ( test )"

DEPEND="
	>=net-libs/libpcap-1.9.0

	nfq?	( net-libs/libmnl )
	test?	( dev-util/cmocka )
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/daq-3.0.19-failed-test-workaround-0.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {

	econf \
		$(use_enable afpacket	afpacket-module) \
		$(use_enable bpf		bpf-module) \
		$(use_enable dump		dump-module) \
		$(use_enable fst		fst-module) \
		$(use_enable nfq		nfq-module) \
		$(use_enable pcap		pcap-module) \
		$(use_enable savefile	savefile-module) \
		$(use_enable trace		trace-module) \
		$(use_enable gwlb		gwlb-module) \
		$(use_enable static-libs static) \
		--disable-bundled-modules \
		--enable-shared
}

DOCS=(
	COPYING
	LICENSE
	README.md
	modules/afpacket/README.afpacket.md
	modules/bpf/README.bpf.md
	modules/divert/README.divert.md
	modules/dump/README.dump.md
	modules/fst/README.fst.md
	modules/gwlb/README.gwlb.md
	modules/netmap/README.netmap.md
	modules/nfq/README.nfq.md
	modules/pcap/README.pcap.md
	modules/savefile/README.savefile.md
	modules/trace/README.trace.md
)

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die

	# If not using static-libs don't install the static libraries
	# This has been bugged upstream
	if ! use static-libs; then
		rm -f "${ED}"/usr/$(get_libdir)/libdaq_static*.a || die
		rm -f "${ED}"/usr/bin/daqtest-static || die
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
