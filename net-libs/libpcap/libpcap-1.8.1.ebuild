# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit autotools eutils multilib-minimal

DESCRIPTION="A system-independent library for user-level network packet capture"
HOMEPAGE="
	http://www.tcpdump.org/
	https://github.com/the-tcpdump-group/libpcap
"
SRC_URI="
	https://github.com/the-tcpdump-group/${PN}/archive/${P}.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="bluetooth dbus netlink static-libs usb"

RDEPEND="
	bluetooth? ( net-wireless/bluez:=[${MULTILIB_USEDEP}] )
	dbus? ( sys-apps/dbus[${MULTILIB_USEDEP}] )
	netlink? ( dev-libs/libnl:3[${MULTILIB_USEDEP}] )
"
DEPEND="
	${RDEPEND}
	sys-devel/flex
	virtual/yacc
	dbus? ( virtual/pkgconfig[${MULTILIB_USEDEP}] )
"

S=${WORKDIR}/${PN}-${P}

PATCHES=(
	"${FILESDIR}"/${PN}-1.6.1-prefix-solaris.patch
	"${FILESDIR}"/${PN}-1.8.1-cross-compile.patch
	"${FILESDIR}"/${PN}-1.8.1-darwin.patch
	"${FILESDIR}"/${PN}-1.8.1-libnl.patch
	"${FILESDIR}"/${PN}-1.8.1-usbmon.patch
)

src_prepare() {
	default

#	mkdir bluetooth || die
#	cp "${FILESDIR}"/mgmt.h bluetooth/ || die

	eapply_user

	echo ${PV} > VERSION || die

	eautoreconf
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" \
	econf \
		$(use_enable bluetooth) \
		$(use_enable usb) \
		$(use_enable dbus) \
		$(use_with netlink libnl) \
		--enable-ipv6
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
