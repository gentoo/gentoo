# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools multilib-minimal

DESCRIPTION="A system-independent library for user-level network packet capture"
HOMEPAGE="
	https://www.tcpdump.org/
	https://github.com/the-tcpdump-group/libpcap
"
SRC_URI="https://github.com/the-tcpdump-group/${PN}/archive/${P/_pre/-bp}.tar.gz"
S="${WORKDIR}/${PN}-${P/_pre/-bp}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ppc64 ~riscv s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~x86-solaris"
IUSE="bluetooth dbus netlink rdma -remote static-libs usb -yydebug"

RDEPEND="
	bluetooth? ( net-wireless/bluez:=[${MULTILIB_USEDEP}] )
	dbus? ( sys-apps/dbus[${MULTILIB_USEDEP}] )
	netlink? ( dev-libs/libnl:3[${MULTILIB_USEDEP}] )
	rdma? ( sys-cluster/rdma-core )
	usb? ( virtual/libusb:1[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/flex
	virtual/yacc
	dbus? ( virtual/pkgconfig )
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.9.1-pcap-config.patch
	"${FILESDIR}"/${PN}-1.10.0-usbmon.patch
)

src_prepare() {
	default

	if ! [[ -f VERSION ]]; then
		echo ${PV} > VERSION || die
	fi

	eautoreconf
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" \
	econf \
		$(use_enable bluetooth) \
		$(use_enable dbus) \
		$(use_enable rdma) \
		$(use_enable remote) \
		$(use_enable usb) \
		$(use_enable yydebug) \
		$(use_with netlink libnl) \
		--enable-ipv6
}

multilib_src_compile() {
	emake all shared
}

multilib_src_install_all() {
	dodoc CREDITS CHANGES VERSION TODO README.* doc/README.*

	# remove static libraries (--disable-static does not work)
	if ! use static-libs; then
		find "${ED}" -name '*.a' -exec rm {} + || die
	fi

	find "${ED}" -name '*.la' -delete || die

	# We need this to build pppd on G/FBSD systems
	if [[ "${USERLAND}" == "BSD" ]]; then
		insinto /usr/include
		doins pcap-int.h portability.h
	fi
}
