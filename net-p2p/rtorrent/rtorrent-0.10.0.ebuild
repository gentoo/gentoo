# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools linux-info systemd

DESCRIPTION="BitTorrent Client using libtorrent"
HOMEPAGE="https://rakshasa.github.io/rtorrent/"
SRC_URI="https://github.com/rakshasa/rtorrent-archive/raw/master/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="debug selinux test xmlrpc"
RESTRICT="!test? ( test )"

COMMON_DEPEND="~net-libs/libtorrent-0.14.${PV##*.}
	net-misc/curl
	sys-libs/ncurses:0=
	xmlrpc? ( dev-libs/xmlrpc-c:= )"
RDEPEND="${COMMON_DEPEND}
	selinux? ( sec-policy/selinux-rtorrent )
"
DEPEND="${COMMON_DEPEND}
	dev-util/cppunit
	virtual/pkgconfig"

DOCS=( doc/rtorrent.rc )

PATCHES=(
	"${FILESDIR}"/${PN}-0.10.0-scgi-software-crash.patch
)

pkg_setup() {
	if ! linux_config_exists || ! linux_chkconfig_present IPV6; then
		ewarn "rtorrent will not start without IPv6 support in your kernel"
		ewarn "without further configuration. Please set bind=0.0.0.0 or"
		ewarn "similar in your rtorrent.rc"
		ewarn "Upstream bug: https://github.com/rakshasa/rtorrent/issues/732"
	fi
}

src_prepare() {
	default

	# https://github.com/rakshasa/rtorrent/issues/332
	cp "${FILESDIR}"/rtorrent.1 "${S}"/doc/ || die

	if [[ ${CHOST} != *-darwin* ]]; then
		# syslibroot is only for macos, change to sysroot for others
		sed -i 's/Wl,-syslibroot,/Wl,--sysroot,/' "${S}/scripts/common.m4" || die
	fi

	eautoreconf
}

src_configure() {
	# configure needs bash or script bombs out on some null shift, bug #291229
	CONFIG_SHELL=${BASH} econf \
		$(use_enable debug) \
		$(use_with xmlrpc xmlrpc-c)
}

src_install() {
	default
	doman doc/rtorrent.1

	newinitd "${FILESDIR}/rtorrent-r1.init" rtorrent
	newconfd "${FILESDIR}/rtorrentd.conf" rtorrent
	systemd_newunit "${FILESDIR}/rtorrentd_at-r1.service" "rtorrentd@.service"
}
