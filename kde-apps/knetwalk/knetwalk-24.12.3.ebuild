# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="forceoptional"
ECM_TEST="forceoptional"
PVCUT=$(ver_cut 1-3)
KFMIN=6.7.0
QTMIN=6.7.2
inherit ecm gear.kde.org

DESCRIPTION="KDE version of the popular NetWalk game for system administrators"
HOMEPAGE="https://apps.kde.org/knetwalk/"

LICENSE="GPL-2" # TODO: CHECK
SLOT="6"
KEYWORDS="~amd64 ~arm64 ~loong ~riscv ~x86"
IUSE=""

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[gui,widgets]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=kde-apps/libkdegames-${PVCUT}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kcrash-${KFMIN}:6
	>=kde-frameworks/kdbusaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/ktextwidgets-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kxmlgui-${KFMIN}:6
"
RDEPEND="${DEPEND}"
# TODO: || ( 7zip gzip )
BDEPEND="app-alternatives/gzip"
