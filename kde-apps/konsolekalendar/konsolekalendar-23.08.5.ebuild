# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="forceoptional"
KDE_ORG_NAME="akonadi-calendar-tools"
PVCUT=$(ver_cut 1-3)
KFMIN=5.106.0
inherit ecm gear.kde.org

DESCRIPTION="Command line interface to KDE calendars"
HOMEPAGE+=" https://userbase.kde.org/KonsoleKalendar"

LICENSE="GPL-2+ handbook? ( FDL-1.2+ )"
SLOT="5"
KEYWORDS="amd64 arm64 ~ppc64 ~x86"
IUSE=""

DEPEND="
	>=kde-apps/akonadi-${PVCUT}:5
	>=kde-apps/akonadi-calendar-${PVCUT}:5
	>=kde-apps/calendarsupport-${PVCUT}:5
	>=kde-frameworks/kcalendarcore-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
"
RDEPEND="${DEPEND}"

src_prepare() {
	ecm_src_prepare

	# delete colliding calendarjanitor translations
	rm -f po/*/calendarjanitor.po || die

	cmake_comment_add_subdirectory calendarjanitor
}
