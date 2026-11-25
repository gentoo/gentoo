# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="true"
KFMIN=6.30.0
QTMIN=6.11.2
inherit ecm plasma.kde.org

DESCRIPTION="Daemon providing Global Keyboard Shortcut (Accelerator) functionality"

LICENSE="LGPL-2+"
SLOT="6"
KEYWORDS="~amd64 ~arm64"
IUSE=""

RESTRICT="test" # requires installed instance

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui]
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/kjobwidgets-${KFMIN}:6
	>=kde-frameworks/knotifications-${KFMIN}:6
	>=kde-frameworks/kservice-${KFMIN}:6
"
RDEPEND="${DEPEND}
	!<kde-frameworks/kglobalaccel-5.116.0-r2:5[-kf6compat(-)]
"
BDEPEND=">=dev-qt/qttools-${QTMIN}:6[linguist]"

# src_test() {
# 	XDG_CURRENT_DESKTOP="KDE" ecm_src_test # bug 789342
# }
