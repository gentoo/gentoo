# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="forceoptional"
KFMIN=6.9.0
QTMIN=6.7.2
inherit ecm gear.kde.org xdg

DESCRIPTION="Tool to check contrast for colors to verify they are correctly accessible"
HOMEPAGE="https://apps.kde.org/kontrast/"

LICENSE="GPL-3+"
SLOT="6"
KEYWORDS="~amd64 ~arm64 ~loong ~riscv ~x86"
IUSE=""

DEPEND="
	dev-db/futuresql
	dev-libs/qcoro
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,sql,widgets]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=dev-qt/qtsvg-${QTMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kcrash-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kirigami-${KFMIN}:6
"
RDEPEND="${DEPEND}
	kde-plasma/xdg-desktop-portal-kde:*
"
