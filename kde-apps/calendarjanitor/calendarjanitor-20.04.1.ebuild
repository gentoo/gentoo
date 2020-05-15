# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_HANDBOOK="forceoptional" # FIXME: Check back for doc in release
ECM_TEST="false"
KDE_ORG_NAME="akonadi-calendar-tools"
PVCUT=$(ver_cut 1-3)
KFMIN=5.70.0
QTMIN=5.12.3
inherit ecm kde.org

DESCRIPTION="Tool to scan calendar data for buggy instances"

LICENSE="GPL-2+ handbook? ( FDL-1.2+ )"
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE=""

DEPEND="
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-apps/akonadi-${PVCUT}:5
	>=kde-apps/akonadi-calendar-${PVCUT}:5
	>=kde-apps/calendarsupport-${PVCUT}:5
	>=kde-frameworks/kcalendarcore-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
"
RDEPEND="${DEPEND}"

src_prepare() {
	ecm_src_prepare

	cmake_comment_add_subdirectory doc konsolekalendar
	sed -i -e "/console\.categories/ s/^/#DONT/" CMakeLists.txt || die

	# delete colliding konsolekalendar translations
	if [[ ${KDE_BUILD_TYPE} = release ]]; then
		rm -f po/*/konsolekalendar.po || die
		rm -rf po/*/docs/konsolekalendar || die
	fi
}
