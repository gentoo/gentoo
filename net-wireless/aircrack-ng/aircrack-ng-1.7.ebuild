# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9,10} )
DISTUTILS_OPTIONAL=1

inherit toolchain-funcs distutils-r1 flag-o-matic autotools

DESCRIPTION="WLAN tools for breaking 802.11 WEP/WPA keys"
HOMEPAGE="http://www.aircrack-ng.org"

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/aircrack-ng/aircrack-ng.git"
else
	MY_PV=${PV/_/-}
	SRC_URI="https://github.com/aircrack-ng/aircrack-ng/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 arm ~arm64 ~ppc x86 ~amd64-linux ~x86-linux"
fi

LICENSE="GPL-2"
SLOT="0"

IUSE="+airdrop-ng +airgraph-ng +netlink +pcre +sqlite +experimental"

DEPEND="net-libs/libpcap
	sys-apps/hwloc:0=
	dev-libs/libbsd
	dev-libs/openssl:0=
	netlink? ( dev-libs/libnl:3 )
	pcre? ( dev-libs/libpcre )
	airdrop-ng? ( ${PYTHON_DEPS} )
	airgraph-ng? ( ${PYTHON_DEPS} )
	experimental? ( sys-libs/zlib )
	sqlite? ( >=dev-db/sqlite-3.4 )"
RDEPEND="${DEPEND}
	kernel_linux? (
		net-wireless/iw
		net-wireless/wireless-tools
		sys-apps/ethtool
		sys-apps/usbutils
		sys-apps/pciutils )
	sys-apps/hwdata
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
