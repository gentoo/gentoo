# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools multilib-minimal

DESCRIPTION="A system-independent library for user-level network packet capture"
HOMEPAGE="https://www.tcpdump.org/ https://github.com/the-tcpdump-group/libpcap"

if [[ ${PV} == *9999* ]] ; then
	EGIT_REPO_URI="https://github.com/the-tcpdump-group/libpcap"
	inherit git-r3
else
	VERIFY_SIG_OPENPGP_KEY_PATH=${BROOT}/usr/share/openpgp-keys/tcpdump.asc
	inherit verify-sig

	# Note: drop -upstream on bump, this is just because we switched to the official
	# distfiles for verify-sig
	SRC_URI="https://www.tcpdump.org/release/${P}.tar.gz -> ${P}-upstream.tar.gz"
	SRC_URI+=" verify-sig? ( https://www.tcpdump.org/release/${P}.tar.gz.sig -> ${P}-upstream.tar.gz.sig )"

	KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~x86-solaris"
fi

LICENSE="BSD"
SLOT="0"
IUSE="bluetooth dbus netlink rdma remote static-libs test usb yydebug"
RESTRICT="!test? ( test )"

RDEPEND="
	bluetooth? ( net-wireless/bluez:=[${MULTILIB_USEDEP}] )
	dbus? ( sys-apps/dbus[${MULTILIB_USEDEP}] )
	netlink? ( dev-libs/libnl:3[${MULTILIB_USEDEP}] )
	remote? ( virtual/libcrypt:=[${MULTILIB_USEDEP}] )
	rdma? ( sys-cluster/rdma-core )
	usb? ( virtual/libusb:1[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/flex
	virtual/yacc
	dbus? ( virtual/pkgconfig )
"

if [[ ${PV} != *9999* ]] ; then
	BDEPEND+=" verify-sig? ( sec-keys/openpgp-keys-tcpdump )"
fi

PATCHES=(
	"${FILESDIR}"/${PN}-1.10.0-usbmon.patch

	# Drop ${P}-pcap-config-no-hardcoded-lib.patch on next release
	"${FILESDIR}"/${P}-pcap-config-no-hardcoded-lib.patch

	# We need to keep this, it's just rebased on top of the above
	# ${P}-pcap-config-no-hardcoded-lib.patch. Drop this comment then too,
	# but keep this patch.
	"${FILESDIR}"/${PN}-1.10.1-pcap-config.patch
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
	use test && emake testprogs
}

multilib_src_test() {
	testprogs/findalldevstest || die
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
