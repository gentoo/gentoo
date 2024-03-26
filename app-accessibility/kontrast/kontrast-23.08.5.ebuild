# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="forceoptional"
KFMIN=5.106.0
QTMIN=5.15.9
inherit ecm gear.kde.org

DESCRIPTION="Tool to check contrast for colors to verify they are correctly accessible"
HOMEPAGE="https://apps.kde.org/kontrast/"

LICENSE="GPL-3+"
SLOT="5"
KEYWORDS="amd64 arm64 ~riscv x86"
IUSE=""

DEPEND="
	dev-db/futuresql5
	dev-libs/qcoro5
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtquickcontrols2-${QTMIN}:5
	>=dev-qt/qtsql-${QTMIN}:5
	>=dev-qt/qtsvg-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kirigami-${KFMIN}:5
"
RDEPEND="${DEPEND}
	kde-plasma/xdg-desktop-portal-kde
"
