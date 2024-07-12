# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PVCUT=$(ver_cut 1-2)
QTMIN=6.6.2
inherit ecm frameworks.kde.org

DESCRIPTION="Framework for providing different actions given a string query"

LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~arm64 ~riscv"
IUSE=""

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui]
	=kde-frameworks/kconfig-${PVCUT}*:6
	=kde-frameworks/kcoreaddons-${PVCUT}*:6
	=kde-frameworks/ki18n-${PVCUT}*:6
	=kde-frameworks/kitemmodels-${PVCUT}*:6
"
RDEPEND="${DEPEND}"

CMAKE_SKIP_TESTS=(
	# requires virtual dbus, otherwise hangs; bugs #630672
	dbusrunnertest
	# bug 789351
	runnermanagersinglerunnermodetest
	# bug 838502
	runnermanagertest
	# bug 926502, needs dbus
	threadingtest
)
