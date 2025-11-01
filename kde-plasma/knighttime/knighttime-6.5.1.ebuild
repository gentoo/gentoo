# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="true"
KFMIN=6.18.0
QTMIN=6.9.1
inherit ecm plasma.kde.org xdg

DESCRIPTION="Helpers for scheduling the dark-light cycle"

LICENSE="BSD CC0-1.0 || ( GPL-2 GPL-3 ) || ( LGPL-2.1 LGPL-3 )"
SLOT="6"
KEYWORDS="~amd64 ~arm64 ~riscv"

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui]
	>=dev-qt/qtpositioning-${QTMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kdbusaddons-${KFMIN}:6
	>=kde-frameworks/kholidays-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
"
RDEPEND="${DEPEND}"
