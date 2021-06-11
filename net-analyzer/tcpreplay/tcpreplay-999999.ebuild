# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools git-r3

DESCRIPTION="Utilities for editing and replaying previously captured network traffic"
HOMEPAGE="http://tcpreplay.appneta.com/ https://github.com/appneta/tcpreplay"
EGIT_REPO_URI="https://github.com/appneta/tcpreplay"
S="${WORKDIR}"/${P/_/-}

LICENSE="BSD GPL-3"
SLOT="0"
IUSE="debug pcapnav +tcpdump"

# libpcapnav for pcapnav-config
BDEPEND="
	net-libs/libpcapnav
	>=sys-devel/autogen-5.18.4[libopts]
"
DEPEND="
	dev-libs/libdnet
	>=net-libs/libpcap-0.9
	pcapnav? ( net-libs/libpcapnav )
	tcpdump? ( net-analyzer/tcpdump )
"
RDEPEND="${DEPEND}"

DOCS=( docs/{CHANGELOG,CREDIT,HACKING,TODO} )

PATCHES=(
	"${FILESDIR}"/${PN}-4.3.0-enable-pcap_findalldevs.patch
)

src_prepare() {
	default

	sed -i \
		-e 's|#include <dnet.h>|#include <dnet/eth.h>|g' \
		src/common/sendpacket.c || die
	sed -i \
		-e 's|@\([A-Z_]*\)@|$(\1)|g' \
		-e '/tcpliveplay_CFLAGS/s|$| $(LDNETINC)|g' \
		-e '/tcpliveplay_LDADD/s|$| $(LDNETLIB)|g' \
		src/Makefile.am || die

	eautoreconf
}

src_configure() {
	# By default it uses static linking. Avoid that, bug 252940
	econf \
		$(use_enable debug) \
		$(use_with pcapnav pcapnav-config "${BROOT}"/usr/bin/pcapnav-config) \
		$(use_with tcpdump tcpdump "${ESYSROOT}"/usr/sbin/tcpdump) \
		--disable-local-libopts \
		--enable-dynamic-link \
		--enable-shared \
		--with-libdnet \
		--with-testnic2=lo \
		--with-testnic=lo
}

src_test() {
	if [[ ! ${EUID} -eq 0 ]]; then
		ewarn "Some tests will be disabled due to FEATURES=userpriv"
		ewarn "To run all tests issue the following command as root:"
		ewarn " # make -C ${S}/test"
		emake -j1 -C test tcpprep
	else
		emake -j1 test || {
			ewarn "Note that some tests require eth0 iface to be up." ;
			die "self test failed - see ${S}/test/test.log" ; }
	fi
}
