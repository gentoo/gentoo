# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libpcap/libpcap-9999.ebuild,v 1.3 2015/07/03 04:20:58 jer Exp $

EAPI=5
inherit autotools eutils git-r3 multilib-minimal

DESCRIPTION="A system-independent library for user-level network packet capture"
HOMEPAGE="http://www.tcpdump.org/"
EGIT_REPO_URI="https://github.com/the-tcpdump-group/libpcap"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
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
	epatch \
		"${FILESDIR}"/${PN}-1.2.0-cross-linux.patch \
		"${FILESDIR}"/${PN}-1.6.1-configure.patch \
		"${FILESDIR}"/${PN}-1.6.1-prefix-solaris.patch \
		"${FILESDIR}"/${PN}-1.7.2-libnl.patch

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
