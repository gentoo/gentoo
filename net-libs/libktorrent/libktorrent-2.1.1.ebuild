# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_TEST="forceoptional"
KFMIN=5.60.0
QTMIN=5.12.3
VIRTUALX_REQUIRED="test"
inherit ecm kde.org

DESCRIPTION="BitTorrent library based on KDE Frameworks"
HOMEPAGE="https://kde.org/applications/internet/org.kde.ktorrent
https://userbase.kde.org/KTorrent"
SRC_URI="mirror://kde/stable/ktorrent/5.1.2/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="5"
KEYWORDS="amd64 ~arm arm64 ~x86"
IUSE=""

BDEPEND="sys-devel/gettext"
COMMON_DEPEND="
	app-crypt/qca:2[qt5(+)]
	>=dev-libs/gmp-6.0.0a:0=
	dev-libs/libgcrypt:0=
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
	>=kde-frameworks/karchive-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/solid-${KFMIN}:5
"
DEPEND="${COMMON_DEPEND}
	dev-libs/boost
"
RDEPEND="${COMMON_DEPEND}
	!dev-libs/botan[gmp(-)]
"

PATCHES=(
	"${FILESDIR}/${P}-fileops.patch" # bug 700090
	"${FILESDIR}/${PN}-2.1-unused-link.patch" # git master
)

src_prepare() {
	ecm_src_prepare

	# Gentoo workaround because gmp.h in MULTILIB_WRAPPED_HEADERS is breaking this
	sed -i -e "/^find_package/ s/\"\${LibGMP_MIN_VERSION}\" //" \
		CMakeLists.txt || die
	sed -i -e "/^find_dependency/ s/ \"@LibGMP_MIN_VERSION@\"//" \
		KF5TorrentConfig.cmake.in || die
}

src_test() {
	# failing network tests
	local myctestargs=(
		-E "(fin|packetloss|send|superseedtest|transmit|utppolltest)"
	)

	ecm_src_test
}
