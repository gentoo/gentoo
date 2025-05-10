# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="forceoff"
ECM_TEST="false"
KDE_ORG_NAME="akonadi-calendar-tools"
PVCUT=$(ver_cut 1-3)
KFMIN=6.13.0
QTMIN=6.7.2
inherit ecm gear.kde.org

DESCRIPTION="Tool to scan calendar data for buggy instances"

LICENSE="GPL-2+"
SLOT="6"
KEYWORDS="~amd64 ~arm64"
IUSE=""

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[widgets]
	>=kde-apps/akonadi-${PVCUT}:6
	>=kde-apps/akonadi-calendar-${PVCUT}:6
	>=kde-apps/calendarsupport-${PVCUT}:6
	>=kde-frameworks/kcalendarcore-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
"
RDEPEND="${DEPEND}
	>=kde-apps/akonadi-calendar-tools-common-${PV}
"

PATCHES=( "${FILESDIR}/${PN}-24.05.2-loggingcategory.patch" )

src_prepare() {
	ecm_src_prepare
	ecm_punt_po_install
	cmake_comment_add_subdirectory konsolekalendar
}
