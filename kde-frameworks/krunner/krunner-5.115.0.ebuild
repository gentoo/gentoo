# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PVCUT=$(ver_cut 1-2)
QTMIN=5.15.9
inherit ecm frameworks.kde.org

DESCRIPTION="Framework for providing different actions given a string query"

LICENSE="LGPL-2+"
KEYWORDS="amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="activities"

DEPEND="
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	=kde-frameworks/kconfig-${PVCUT}*:5
	=kde-frameworks/kcoreaddons-${PVCUT}*:5
	=kde-frameworks/ki18n-${PVCUT}*:5
	=kde-frameworks/kio-${PVCUT}*:5
	=kde-frameworks/kservice-${PVCUT}*:5
	=kde-frameworks/threadweaver-${PVCUT}*:5
	=kde-plasma/libplasma-${PVCUT}*:5
	activities? ( =kde-plasma/plasma-activities-${PVCUT}*:5 )
"
RDEPEND="${DEPEND}"

CMAKE_SKIP_TESTS=(
	# requires virtual dbus, otherwise hangs; bugs #630672
	dbusrunnertest
	# bug 789351
	runnermanagersinglerunnermodetest
	# bug 838502
	runnermanagertest
)

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package activities KF5Activities)
	)
	ecm_src_configure
}
