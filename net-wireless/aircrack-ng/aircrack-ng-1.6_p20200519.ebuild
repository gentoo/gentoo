# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
DISTUTILS_OPTIONAL=1

inherit toolchain-funcs distutils-r1 flag-o-matic autotools

DESCRIPTION="WLAN tools for breaking 802.11 WEP/WPA keys"
HOMEPAGE="http://www.aircrack-ng.org"

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/aircrack-ng/aircrack-ng.git"
else
	#SRC_URI="https://download.aircrack-ng.org/${P}.tar.gz"
	COMMIT="225993949cd1c8228227ab4e6d315538a908c101"
	SRC_URI="https://github.com/aircrack-ng/aircrack-ng/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-${COMMIT}"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~x86 ~amd64-linux ~x86-linux"
fi

LICENSE="GPL-2"
SLOT="0"

IUSE="+airdrop-ng +airgraph-ng kernel_linux kernel_FreeBSD libressl +netlink +pcre +sqlite +experimental"

DEPEND="net-libs/libpcap
	sys-apps/hwloc:0=
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	netlink? ( dev-libs/libnl:3 )
	pcre? ( dev-libs/libpcre )
	airdrop-ng? ( ${PYTHON_DEPS} )
	airgraph-ng? ( ${PYTHON_DEPS} )
	experimental? ( sys-libs/zlib )
	sqlite? ( >=dev-db/sqlite-3.4 )"
RDEPEND="${DEPEND}"
PDEPEND="kernel_linux? (
		net-wireless/iw
		net-wireless/wireless-tools
		sys-apps/ethtool
		sys-apps/usbutils
		sys-apps/pciutils )
	sys-apps/hwids
	airdrop-ng? ( net-wireless/lorcon[python,${PYTHON_USEDEP}] )"

REQUIRED_USE="
	airdrop-ng? ( ${PYTHON_REQUIRED_USE} )
	airgraph-ng? ( ${PYTHON_REQUIRED_USE} )"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		STATIC_LIBDIR_NAME="$(get_libdir)" \
		--disable-asan \
		--enable-shared \
		--disable-static \
		--without-opt \
		$(use_enable netlink libnl) \
		$(use_with experimental) \
		$(use_with sqlite sqlite3)
}

src_compile() {
	if [[ $($(tc-getCC) --version) == clang* ]] ; then
		#https://bugs.gentoo.org/show_bug.cgi?id=472890
		filter-flags -frecord-gcc-switches
	fi

	default

	if use airgraph-ng; then
		cd "${S}/scripts/airgraph-ng"
		distutils-r1_src_compile
	fi
	if use airdrop-ng; then
		cd "${S}/scripts/airdrop-ng"
		distutils-r1_src_compile
	fi
}

src_install() {
	default

	if use airgraph-ng; then
		cd "${S}/scripts/airgraph-ng"
		distutils-r1_src_install
	fi
	if use airdrop-ng; then
		cd "${S}/scripts/airdrop-ng"
		distutils-r1_src_install
	fi

	# we don't need aircrack-ng's oui updater, we have our own
	rm "${ED}"/usr/sbin/airodump-ng-oui-update
	find "${D}" -xtype f -name '*.la' -delete || die
}

pkg_postinst() {
	# Message is (c) FreeBSD
	# http://www.freebsd.org/cgi/cvsweb.cgi/ports/net-mgmt/aircrack-ng/files/pkg-message.in?rev=1.5
	if use kernel_FreeBSD ; then
		einfo "Contrary to Linux, it is not necessary to use airmon-ng to enable the monitor"
		einfo "mode of your wireless card.  So do not care about what the manpages say about"
		einfo "airmon-ng, airodump-ng sets monitor mode automatically."
		echo
		einfo "To return from monitor mode, issue the following command:"
		einfo "    ifconfig \${INTERFACE} -mediaopt monitor"
		einfo
		einfo "For aireplay-ng you need FreeBSD >= 7.0."
	fi
}
