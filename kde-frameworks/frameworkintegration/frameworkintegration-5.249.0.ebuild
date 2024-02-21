# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_QTHELP="false"
PVCUT=$(ver_cut 1-2)
QTMIN=6.6.2
inherit ecm frameworks.kde.org

DESCRIPTION="Framework for integrating Qt applications with KDE Plasma workspaces"

LICENSE="LGPL-2+"
KEYWORDS="~amd64"
IUSE=""

# requires running Plasma environment
RESTRICT="test"

RDEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[gui,widgets]
	=kde-frameworks/kcolorscheme-${PVCUT}*:6
	=kde-frameworks/kconfig-${PVCUT}*:6
	=kde-frameworks/ki18n-${PVCUT}*:6
	=kde-frameworks/kiconthemes-${PVCUT}*:6
	=kde-frameworks/knewstuff-${PVCUT}*:6
	=kde-frameworks/knotifications-${PVCUT}*:6
	=kde-frameworks/kwidgetsaddons-${PVCUT}*:6
"
DEPEND="${RDEPEND}
	=kde-frameworks/kpackage-${PVCUT}*:6
"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_AppStreamQt=ON
		-DCMAKE_DISABLE_FIND_PACKAGE_packagekitqt6=ON
	)

	ecm_src_configure
}
