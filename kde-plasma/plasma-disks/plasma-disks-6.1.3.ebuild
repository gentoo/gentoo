# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="true"
KFMIN=6.3.0
QTMIN=6.7.1
inherit ecm plasma.kde.org

DESCRIPTION="Monitors S.M.A.R.T. capable devices for imminent failure"
HOMEPAGE="https://invent.kde.org/plasma/plasma-disks"

LICENSE="|| ( GPL-3 GPL-2 )"
SLOT="6"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE=""

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=kde-frameworks/kauth-${KFMIN}:6
	>=kde-frameworks/kcmutils-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kdbusaddons-${KFMIN}:6
	>=kde-frameworks/kdeclarative-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/kjobwidgets-${KFMIN}:6
	>=kde-frameworks/knotifications-${KFMIN}:6
	>=kde-frameworks/kservice-${KFMIN}:6
	>=kde-frameworks/solid-${KFMIN}:6
	sys-apps/smartmontools
"
RDEPEND="${DEPEND}
	kde-plasma/kinfocenter:6
"
BDEPEND=">=kde-frameworks/kcmutils-${KFMIN}:6"
