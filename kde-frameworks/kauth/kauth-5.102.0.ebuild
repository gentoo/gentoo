# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PVCUT=$(ver_cut 1-2)
QTMIN=5.15.5
VIRTUALX_REQUIRED="test"
inherit ecm frameworks.kde.org

DESCRIPTION="Framework to let applications perform actions as a privileged user"

LICENSE="LGPL-2.1+"
KEYWORDS="amd64 ~arm arm64 ~loong ~ppc64 ~riscv x86"
IUSE="+policykit"

DEPEND="
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	=kde-frameworks/kcoreaddons-${PVCUT}*:5
	policykit? ( >=sys-auth/polkit-qt-0.113.0[qt5(+)] )
"
RDEPEND="${DEPEND}"
BDEPEND=">=dev-qt/linguist-tools-${QTMIN}:5"
PDEPEND="policykit? ( kde-plasma/polkit-kde-agent )"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package policykit PolkitQt5-1)
	)

	ecm_src_configure
}

src_test() {
	# KAuthHelperTest test fails, bug 654842
	local myctestargs=(
		-E "(KAuthHelperTest)"
	)

	ecm_src_test
}
