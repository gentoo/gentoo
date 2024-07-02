# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="forceoptional" # FIXME: Check back for doc in release
ECM_TEST="false"
KDE_ORG_NAME="akonadi-calendar-tools"
PVCUT=$(ver_cut 1-3)
KFMIN=6.3.0
QTMIN=6.6.2
inherit ecm gear.kde.org

DESCRIPTION="Tool to scan calendar data for buggy instances"

LICENSE="GPL-2+ handbook? ( FDL-1.2+ )"
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
RDEPEND="${DEPEND}"

src_prepare() {
	ecm_src_prepare

	cmake_comment_add_subdirectory doc konsolekalendar
	sed -i -e "/console\.categories/ s/^/#DONT/" CMakeLists.txt || die

	# delete colliding konsolekalendar translations
	rm -f po/*/konsolekalendar.po || die
	rm -rf po/*/docs/konsolekalendar || die
}
