# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PVCUT=$(ver_cut 1-2)
QTMIN=6.6.2
inherit ecm frameworks.kde.org

DESCRIPTION="Framework providing elaborate user-interface components"

LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~arm64 ~riscv"
IUSE=""

RDEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[gui,widgets,xml]
	=kde-frameworks/kconfig-${PVCUT}*:6
	=kde-frameworks/kcoreaddons-${PVCUT}*:6
	=kde-frameworks/ki18n-${PVCUT}*:6
	=kde-frameworks/kiconthemes-${PVCUT}*:6
	=kde-frameworks/kio-${PVCUT}*:6
	=kde-frameworks/kjobwidgets-${PVCUT}*:6
	=kde-frameworks/kservice-${PVCUT}*:6
	=kde-frameworks/kwidgetsaddons-${PVCUT}*:6
	=kde-frameworks/kxmlgui-${PVCUT}*:6
"
DEPEND="${RDEPEND}"
