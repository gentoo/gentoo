# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PVCUT=$(ver_cut 1-2)
QTMIN=6.6.2
inherit ecm frameworks.kde.org

DESCRIPTION="Advanced plugin and service introspection"

LICENSE="LGPL-2 LGPL-2.1+"
KEYWORDS="~amd64 ~arm64 ~riscv ~x86"
IUSE="+man"

# requires running kde environment
RESTRICT="test"

RDEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus,xml]
	=kde-frameworks/kconfig-${PVCUT}*:6
	=kde-frameworks/kcoreaddons-${PVCUT}*:6
	=kde-frameworks/kdbusaddons-${PVCUT}*:6
	=kde-frameworks/ki18n-${PVCUT}*:6
"
DEPEND="${RDEPEND}
	test? ( >=dev-qt/qtbase-${QTMIN}:6[concurrent] )
"
BDEPEND="man? ( >=kde-frameworks/kdoctools-${PVCUT}:6 )"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package man KF6DocTools)
	)

	ecm_src_configure
}
