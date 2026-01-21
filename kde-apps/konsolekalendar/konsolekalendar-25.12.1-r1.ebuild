# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="forceoff"
KDE_ORG_NAME="akonadi-calendar-tools"
PVCUT=$(ver_cut 1-3)
KFMIN=6.22.0
inherit ecm gear.kde.org xdg

DESCRIPTION="Command line interface to KDE calendars"
HOMEPAGE+=" https://userbase.kde.org/KonsoleKalendar"

LICENSE="GPL-2+"
SLOT="6"
KEYWORDS="~amd64 ~arm64"
IUSE=""

DEPEND="
	>=kde-apps/akonadi-${PVCUT}:6=
	>=kde-apps/akonadi-calendar-${PVCUT}:6=
	>=kde-apps/calendarsupport-${PVCUT}:6=
	>=kde-frameworks/kcalendarcore-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
"
RDEPEND="${DEPEND}
	>=kde-apps/akonadi-calendar-tools-common-${PV}
"

src_prepare() {
	ecm_src_prepare
	ecm_punt_po_install
	cmake_comment_add_subdirectory calendarjanitor
}
