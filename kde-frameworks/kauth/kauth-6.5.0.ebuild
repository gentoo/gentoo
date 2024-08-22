# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PVCUT=$(ver_cut 1-2)
QTMIN=6.6.2
inherit ecm frameworks.kde.org

DESCRIPTION="Framework to let applications perform actions as a privileged user"

LICENSE="LGPL-2.1+"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE="+policykit"

RDEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[gui]
	=kde-frameworks/kcoreaddons-${PVCUT}*:6
	policykit? (
		>=dev-qt/qtbase-${QTMIN}:6[dbus]
		=kde-frameworks/kwindowsystem-${PVCUT}*:6[wayland]
		>=sys-auth/polkit-qt-0.113.0[qt6(-)]
	)
"
DEPEND="${RDEPEND}
	test? ( >=dev-qt/qtbase-${QTMIN}:6[dbus] )
"
BDEPEND=">=dev-qt/qttools-${QTMIN}:6[linguist]"
PDEPEND="policykit? ( kde-plasma/polkit-kde-agent:* )"

CMAKE_SKIP_TESTS=(
	# KAuthHelperTest test fails, bug 654842
	KAuthHelperTest
)

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package policykit PolkitQt6-1)
	)

	ecm_src_configure
}
