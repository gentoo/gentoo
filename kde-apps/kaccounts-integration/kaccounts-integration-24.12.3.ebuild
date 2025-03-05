# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="forceoptional"
KFMIN=6.7.0
PVCUT=$(ver_cut 1-3)
QTMIN=6.7.2
VIRTUALDBUS_TEST="true"
inherit ecm gear.kde.org

DESCRIPTION="Administer web accounts for the sites and services across the Plasma desktop"
HOMEPAGE="https://community.kde.org/KTp"

LICENSE="LGPL-2.1"
SLOT="6"
KEYWORDS="~amd64 ~arm64"
IUSE=""

# bug #549444
RESTRICT="test"

COMMON_DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[gui,widgets]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kdbusaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/kwallet-${KFMIN}:6
	>=net-libs/accounts-qt-1.17-r2
	>=net-libs/signond-8.61-r102
"
DEPEND="${COMMON_DEPEND}
	dev-libs/qcoro
	>=kde-frameworks/kcmutils-${KFMIN}:6
"
RDEPEND="${COMMON_DEPEND}
	kde-apps/signon-kwallet-extension:6
"
BDEPEND="sys-devel/gettext"
PDEPEND=">=kde-apps/kaccounts-providers-${PVCUT}:6"

src_configure() {
	local mycmakeargs=( -DKF6_COMPAT_BUILD=OFF )
	ecm_src_configure
}
