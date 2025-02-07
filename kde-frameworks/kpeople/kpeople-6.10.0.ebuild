# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QTMIN=6.7.2
VIRTUALX_REQUIRED="test" # bug 816588 (test fails)
inherit ecm frameworks.kde.org

DESCRIPTION="KDE contact person abstraction library"
HOMEPAGE="https://invent.kde.org/frameworks/kpeople"

LICENSE="LGPL-2.1"
KEYWORDS="~amd64 arm64 ~ppc64 ~riscv ~x86"
IUSE=""

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,sql,widgets]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	=kde-frameworks/kconfig-${KDE_CATV}*:6
	=kde-frameworks/kcontacts-${KDE_CATV}*:6
	=kde-frameworks/kcoreaddons-${KDE_CATV}*:6
	=kde-frameworks/ki18n-${KDE_CATV}*:6
	=kde-frameworks/kitemviews-${KDE_CATV}*:6
	=kde-frameworks/kwidgetsaddons-${KDE_CATV}*:6
"
RDEPEND="${DEPEND}"

src_test() {
	local CMAKE_SKIP_TESTS=(
		# bugs 668192, 816588: segfaults w/o virtx
		personsmodeltest
	)

	ecm_src_test -j1
}
