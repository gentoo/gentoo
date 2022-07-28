# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="true"
KFMIN=5.92.0
PVCUT=$(ver_cut 1-3)
QTMIN=5.15.4
inherit ecm plasma.kde.org

DESCRIPTION="Plasma integration for controlling Thunderbolt devices"
HOMEPAGE="https://invent.kde.org/plasma/plasma-thunderbolt"

LICENSE="|| ( GPL-2 GPL-3+ )"
SLOT="5"
KEYWORDS="amd64 ~riscv ~x86"
IUSE=""

# tests require DBus
RESTRICT="test"

DEPEND="
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=kde-frameworks/kcmutils-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kdbusaddons-${KFMIN}:5
	>=kde-frameworks/kdeclarative-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/knotifications-${KFMIN}:5
"
RDEPEND="${DEPEND}
	>=dev-qt/qtquickcontrols2-${QTMIN}:5
	>=kde-frameworks/kirigami-${KFMIN}:5
	sys-apps/bolt
"
