# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libpcap/libpcap-1.7.3.ebuild,v 1.4 2015/06/24 08:04:26 ago Exp $

EAPI=5
inherit autotools eutils multilib-minimal

DESCRIPTION="A system-independent library for user-level network packet capture"
HOMEPAGE="http://www.tcpdump.org/"
SRC_URI="http://www.tcpdump.org/release/${P}.tar.gz
	http://www.jp.tcpdump.org/release/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ppc ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="bluetooth dbus ipv6 netlink static-libs canusb"

RDEPEND="
	bluetooth? ( net-wireless/bluez:=[${MULTILIB_USEDEP}] )
	dbus? ( sys-apps/dbus[${MULTILIB_USEDEP}] )
	netlink? ( dev-libs/libnl:3[${MULTILIB_USEDEP}] )
	canusb? ( virtual/libusb:1[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}
	sys-devel/flex
	virtual/yacc
	dbus? ( virtual/pkgconfig[${MULTILIB_USEDEP}] )
"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.2.0-cross-linux.patch
	epatch "${FILESDIR}"/${PN}-1.6.1-configure.patch
	epatch "${FILESDIR}"/${PN}-1.6.1-prefix-solaris.patch
	epatch "${FILESDIR}"/${PN}-1.7.2-libnl.patch
	epatch "${FILESDIR}"/${PN}-1.7.2-scanner.patch

	mkdir bluetooth || die
	cp "${FILESDIR}"/mgmt.h bluetooth/ || die

	eautoreconf
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" \
	econf \
		$(use_enable bluetooth) \
		$(use_enable ipv6) \
		$(use_enable canusb) \
		$(use_enable dbus) \
		$(use_with netlink libnl)
}

multilib_src_compile() {
	emake all shared
}

multilib_src_install_all() {
	dodoc CREDITS CHANGES VERSION TODO README{,.dag,.linux,.macosx,.septel}

	# remove static libraries (--disable-static does not work)
	if ! use static-libs; then
		find "${ED}" -name '*.a' -exec rm {} + || die
	fi
	prune_libtool_files

	# We need this to build pppd on G/FBSD systems
	if [[ "${USERLAND}" == "BSD" ]]; then
		insinto /usr/include
		doins pcap-int.h
	fi
}
