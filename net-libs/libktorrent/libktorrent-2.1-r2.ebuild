# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_TEST="forceoptional"
VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="BitTorrent library based on KDE Frameworks"
HOMEPAGE="https://kde.org/applications/internet/ktorrent/"
SRC_URI="mirror://kde/stable/ktorrent/5.1/${P}.tar.xz"

LICENSE="GPL-2+"
KEYWORDS="amd64 ~arm arm64 x86"
IUSE=""

BDEPEND="sys-devel/gettext"
COMMON_DEPEND="
	$(add_frameworks_dep karchive)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kcrash)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep solid)
	$(add_qt_dep qtnetwork)
	$(add_qt_dep qtxml)
	app-crypt/qca:2[qt5(+)]
	>=dev-libs/gmp-6.0.0a:0=
	dev-libs/libgcrypt:0=
"
DEPEND="${COMMON_DEPEND}
	dev-libs/boost
"
RDEPEND="${COMMON_DEPEND}
	!dev-libs/botan[gmp(-)]
"

PATCHES=( "${FILESDIR}/${P}-unused-link.patch" )

src_prepare() {
	kde5_src_prepare

	# Gentoo workaround because gmp.h in MULTILIB_WRAPPED_HEADERS is breaking this
	sed -i -e "/^find_package/ s/\"\${LibGMP_MIN_VERSION}\" //" \
		CMakeLists.txt || die
	sed -i -e "/^find_dependency/ s/ \"@LibGMP_MIN_VERSION@\"//" \
		KF5TorrentConfig.cmake.in || die
}

src_test() {
	# failing network tests
	local myctestargs=(
		-E "(fin|packetloss|send|transmit)"
	)

	kde5_src_test
}
