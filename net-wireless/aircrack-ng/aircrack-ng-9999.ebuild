# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..12} )
DISTUTILS_OPTIONAL=1

inherit distutils-r1 autotools

DESCRIPTION="WLAN tools for breaking 802.11 WEP/WPA keys"
HOMEPAGE="http://www.aircrack-ng.org"

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/aircrack-ng/aircrack-ng.git"
else
	MY_PV=${PV/_/-}
	SRC_URI="https://github.com/aircrack-ng/aircrack-ng/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~x86 ~amd64-linux ~x86-linux"
fi

LICENSE="GPL-2"
SLOT="0"

IUSE="+airdrop-ng +airgraph-ng +experimental +netlink +pcre +sqlite test"

CDEPEND="net-libs/libpcap
	sys-apps/hwloc:0=
	dev-libs/libbsd
	dev-libs/openssl:0=
	netlink? ( dev-libs/libnl:3 )
	pcre? ( dev-libs/libpcre2:= )
	airdrop-ng? ( ${PYTHON_DEPS} )
	airgraph-ng? ( ${PYTHON_DEPS} )
	experimental? ( sys-libs/zlib )
	sqlite? ( >=dev-db/sqlite-3.4:3 )
	"
DEPEND="${CDEPEND}
	test? ( dev-tcltk/expect )
	"
RDEPEND="${CDEPEND}
	kernel_linux? (
		net-wireless/iw
		net-wireless/wireless-tools
		sys-apps/ethtool
		sys-apps/usbutils
		sys-apps/pciutils )
	sys-apps/hwdata
	airdrop-ng? ( net-wireless/lorcon[python,${PYTHON_USEDEP}] )"
BDEPEND="airdrop-ng? ( ${DISTUTILS_DEPS} )
	airgraph-ng? ( ${DISTUTILS_DEPS} )"

REQUIRED_USE="airdrop-ng? ( ${PYTHON_REQUIRED_USE} )
	airgraph-ng? ( ${PYTHON_REQUIRED_USE} )"

RESTRICT="!test? ( test )"

src_prepare() {
	default
	eautoreconf
	if use airgraph-ng || use airdrop-ng; then
		distutils-r1_src_prepare
	fi
}

src_configure() {
	econf \
		STATIC_LIBDIR_NAME="$(get_libdir)" \
		--disable-asan \
		--enable-shared \
		--disable-static \
		--without-opt \
		--with-duma=no \
		$(use_enable netlink libnl) \
		$(use_with experimental) \
		$(use_with sqlite sqlite3)
}

python_compile() {
	if use airgraph-ng; then
		cd "${S}/scripts/airgraph-ng" || die
		distutils-r1_python_compile
	fi
	if use airdrop-ng; then
		if [ -d "${BUILD_DIR}"/build ]; then
			rm -r "${BUILD_DIR}"/build || die
		fi
		cd "${S}/scripts/airdrop-ng" || die
		distutils-r1_python_compile
	fi
}

src_compile() {
	default
	if use airgraph-ng || use airdrop-ng; then
		distutils-r1_src_compile
	fi
}

src_install() {
	default
	if use airgraph-ng || use airdrop-ng; then
		distutils-r1_src_install
	fi

	# we don't need aircrack-ng's oui updater, we have our own
	rm "${ED}"/usr/sbin/airodump-ng-oui-update || die
	find "${D}" -xtype f -name '*.la' -delete || die
}
