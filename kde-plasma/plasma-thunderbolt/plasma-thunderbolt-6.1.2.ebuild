# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="true"
KFMIN=6.3.0
QTMIN=6.7.1
inherit ecm plasma.kde.org

DESCRIPTION="Plasma integration for controlling Thunderbolt devices"
HOMEPAGE="https://invent.kde.org/plasma/plasma-thunderbolt"

LICENSE="|| ( GPL-2 GPL-3+ )"
SLOT="6"
KEYWORDS="~amd64 ~riscv ~x86"
IUSE=""

# tests require DBus
RESTRICT="test"

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=kde-frameworks/kcmutils-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kdbusaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/knotifications-${KFMIN}:6
	>=kde-frameworks/kservice-${KFMIN}:6
"
RDEPEND="${DEPEND}
	>=kde-frameworks/kirigami-${KFMIN}:6
	sys-apps/bolt
"
BDEPEND=">=kde-frameworks/kcmutils-${KFMIN}:6"
