# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_QTHELP="false"
ECM_TEST="false"
QTMIN=6.10.1
inherit ecm frameworks.kde.org

DESCRIPTION="Central daemon of KDE workspaces"

LICENSE="LGPL-2+"
KEYWORDS="amd64 arm64 ~loong ppc64 ~riscv ~x86"
IUSE="+man"

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,widgets]
	=kde-frameworks/kconfig-${KDE_CATV}*:6[dbus]
	=kde-frameworks/kcoreaddons-${KDE_CATV}*:6
	=kde-frameworks/kcrash-${KDE_CATV}*:6
	=kde-frameworks/kdbusaddons-${KDE_CATV}*:6
	=kde-frameworks/kservice-${KDE_CATV}*:6
"
RDEPEND="${DEPEND}"
BDEPEND="man? ( >=kde-frameworks/kdoctools-${KDE_CATV}:6 )"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package man KF6DocTools)
	)

	ecm_src_configure
}
