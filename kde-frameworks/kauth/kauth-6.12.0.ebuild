# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QTMIN=6.7.2
inherit ecm frameworks.kde.org

DESCRIPTION="Framework to let applications perform actions as a privileged user"

LICENSE="LGPL-2.1+"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE="+policykit"

RDEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[gui]
	=kde-frameworks/kcoreaddons-${KDE_CATV}*:6
	policykit? (
		>=dev-qt/qtbase-${QTMIN}:6[dbus]
		=kde-frameworks/kwindowsystem-${KDE_CATV}*:6[wayland]
		>=sys-auth/polkit-qt-0.175.0[qt6(+)]
	)
"
DEPEND="${RDEPEND}
	test? ( >=dev-qt/qtbase-${QTMIN}:6[dbus] )
"
BDEPEND=">=dev-qt/qttools-${QTMIN}:6[linguist]"
PDEPEND="policykit? ( kde-plasma/polkit-kde-agent:* )"

CMAKE_SKIP_TESTS=(
	# fails, bug 654842
	KAuthHelperTest
	# needs DBus, bug 938505
	KAuthFdTest
)

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package policykit PolkitQt6-1)
	)

	ecm_src_configure
}
