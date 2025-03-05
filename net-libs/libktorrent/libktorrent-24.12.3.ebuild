# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="forceoptional"
KDE_ORG_CATEGORY="network"
KFMIN=6.7.0
QTMIN=6.7.2
inherit ecm gear.kde.org

DESCRIPTION="BitTorrent library based on KDE Frameworks"
HOMEPAGE="https://apps.kde.org/ktorrent/ https://userbase.kde.org/KTorrent"

LICENSE="GPL-2+"
SLOT="6"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE="xfs"

COMMON_DEPEND="
	>=app-crypt/qca-2.3.7:2[qt6(+)]
	>=dev-libs/gmp-6.0.0a:0=
	dev-libs/libgcrypt:0=
	>=dev-qt/qtbase-${QTMIN}:6[network,xml]
	>=dev-qt/qt5compat-${QTMIN}:6
	>=kde-frameworks/karchive-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kcrash-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/solid-${KFMIN}:6
	xfs? ( sys-fs/xfsprogs )
"
DEPEND="${COMMON_DEPEND}
	>=dev-libs/boost-1.71
"
RDEPEND="${COMMON_DEPEND}
	!dev-libs/botan[gmp(-)]
"
BDEPEND="sys-devel/gettext"

src_prepare() {
	ecm_src_prepare

	# Gentoo workaround because gmp.h in MULTILIB_WRAPPED_HEADERS is breaking this
	sed -i -e "/^find_package/ s/\"\${LibGMP_MIN_VERSION}\" //" \
		CMakeLists.txt || die
	sed -i -e "/^find_dependency/ s/ \"@LibGMP_MIN_VERSION@\"//" \
		KTorrent6Config.cmake.in || die
}

src_configure() {
	local mycmakeargs=(
		-DWITH_XFS=$(usex xfs)
	)
	ecm_src_configure
}

src_test() {
	# failing network tests
	local myctestargs=(
		-E "(fin|packetloss|send|superseedtest|transmit|utppolltest)"
	)
	ecm_src_test
}
