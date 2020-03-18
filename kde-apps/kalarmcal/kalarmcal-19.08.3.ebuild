# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_TEST="true"
PVCUT=$(ver_cut 1-3)
KFMIN=5.60.0
QTMIN=5.12.3
inherit ecm kde.org

DESCRIPTION="Client library to access and handling of KAlarm calendar data"
LICENSE="GPL-2+ LGPL-2.1+"
SLOT="5"
KEYWORDS="amd64 arm64 x86"
IUSE=""

COMMON_DEPEND="
	>=kde-frameworks/kcalendarcore-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kholidays-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-apps/akonadi-${PVCUT}:5
	>=kde-apps/kcalutils-${PVCUT}:5
	>=kde-apps/kidentitymanagement-${PVCUT}:5
	>=dev-qt/qtgui-${QTMIN}:5
"
DEPEND="${COMMON_DEPEND}
	test? ( >=dev-qt/qtdbus-${QTMIN}:5 )
"
RDEPEND="${COMMON_DEPEND}
	!kde-apps/kdepim-l10n
	!<kde-apps/kdepim-runtime-18.03.80
"

src_test() {
	LANG="C" ecm_src_test #bug 665626
}
