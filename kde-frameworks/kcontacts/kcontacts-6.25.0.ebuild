# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="true"
QTMIN=6.10.1
inherit ecm frameworks.kde.org

DESCRIPTION="Address book API based on KDE Frameworks"

LICENSE="GPL-2+"
KEYWORDS="amd64 arm64 ~ppc64 ~riscv ~x86"
IUSE=""

RDEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[gui]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	=kde-frameworks/kcodecs-${KDE_CATV}*:6
	=kde-frameworks/kconfig-${KDE_CATV}*:6
	=kde-frameworks/kcoreaddons-${KDE_CATV}*:6
	=kde-frameworks/ki18n-${KDE_CATV}*:6
"
DEPEND="${RDEPEND}"

CMAKE_SKIP_TESTS=(
	# bug #566648 (access to /dev/dri/card0 denied)
	kcontacts-picturetest
	# bugs #712798, 838502, 953969 (again some Qt translations loading related err...)
	kcontacts-{address{,format},phonenumber}test
)
