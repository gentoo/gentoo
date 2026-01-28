# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_QTHELP="true"
ECM_TEST="true"
KFMIN=6.18.0
QTMIN=6.10.1
inherit ecm plasma.kde.org

DESCRIPTION="Core components for KDE's Activities System"

LICENSE="|| ( LGPL-2.1 LGPL-3 )"
SLOT="6/7"
KEYWORDS="amd64 arm64 ~loong ppc64 ~riscv ~x86"
IUSE=""

RDEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,sql,widgets]
	>=dev-qt/qtdeclarative-${QTMIN}:6[widgets]
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
"
DEPEND="${RDEPEND}
	test? ( >=kde-frameworks/kwindowsystem-${KFMIN}:6[X] )
"
