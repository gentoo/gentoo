# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit autotools base multilib

DESCRIPTION="Open-source implementation of the Secure Real-time Transport Protocol (SRTP)"
HOMEPAGE="https://github.com/cisco/libsrtp"
SRC_URI="https://github.com/cisco/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 -sparc ~x86 ~x86-fbsd ~ppc-macos ~x64-macos ~x86-macos"
IUSE="aesicm console debug doc openssl static-libs syslog"

DEPEND="openssl? ( dev-libs/openssl:0 )"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${PN}-pcap-automagic-r0.patch"
	eautoreconf || die
}

src_configure() {
	# stdout: default error output for messages in debug
	# kernel-linux: breaks the build
	# gdoi: disabled by upstream and breaks the build
	# pcap: seems to be test-only
	econf \
		--enable-stdout \
		--disable-kernel-linux \
		--disable-gdoi \
		--disable-pcap \
		$(use_enable aesicm generic-aesicm) \
		$(use_enable console) \
		$(use_enable debug) \
		$(use_enable openssl) \
		$(use_enable syslog)
}

src_compile() {
	if use static-libs; then
		emake ${PN}.a || die
	fi
	emake shared_library || die
}

src_test() {
	# getopt returns an int, not a char
	sed -i -e "s/char q/int q/" \
		test/rdbx_driver.c test/srtp_driver.c test/dtls_srtp_driver.c || die

	# test/rtpw_test.sh is assuming . is in $PATH
	sed -i -e "s:\$RTPW :./\$RTPW :" test/rtpw_test.sh || die

	# test/rtpw.c is using /usr/share/dict/words assuming it exists
	# using test/rtpw.c guaratees the file exists in any case
	sed -i -e "s:/usr/share/dict/words:rtpw.c:" test/rtpw.c || die

	emake test || die
	emake -j1 runtest || die
}

src_install() {
	emake DESTDIR="${D}" install || die

	dodoc CHANGES README TODO || die

	if use doc; then
		# libsrtp.pdf can also be generated with doxygen
		# but it would be a waste of time as an up-to-date version is built
		dodoc doc/*.txt doc/${PN}.pdf || die
	fi
}
