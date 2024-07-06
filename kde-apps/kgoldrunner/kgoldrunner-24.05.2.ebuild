# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="forceoptional"
KDE_SELINUX_MODULE="games"
PVCUT=$(ver_cut 1-3)
KFMIN=6.3.0
QTMIN=6.6.2
inherit ecm gear.kde.org

DESCRIPTION="Game of action and puzzle solving by KDE"
HOMEPAGE="https://apps.kde.org/kgoldrunner/"

LICENSE="GPL-2" # TODO: CHECK
SLOT="6"
KEYWORDS="~amd64 ~arm64 ~riscv"
IUSE=""

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[gui,widgets]
	>=kde-apps/libkdegames-${PVCUT}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kcrash-${KFMIN}:6
	>=kde-frameworks/kdbusaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kxmlgui-${KFMIN}:6
	media-libs/libsndfile
	media-libs/openal
"
RDEPEND="${DEPEND}
	>=dev-qt/qtsvg-${QTMIN}:6
"
BDEPEND="app-alternatives/gzip"
