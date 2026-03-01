# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_QTHELP="true"
ECM_TEST="true"
KFMIN=6.22.0
QTMIN=6.10.1
inherit ecm gear.kde.org

DESCRIPTION="Extended text editor for PIM applications"

LICENSE="LGPL-2.1+"
SLOT="6/$(ver_cut 1-2)"
KEYWORDS="amd64 arm64"
IUSE=""

RESTRICT="test"

RDEPEND="
	>=dev-libs/ktextaddons-1.8.0:6
	>=dev-qt/qtbase-${QTMIN}:6[widgets]
	>=kde-frameworks/kcodecs-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kiconthemes-${KFMIN}:6
	>=kde-frameworks/kio-6.22.1:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kxmlgui-${KFMIN}:6
	>=kde-frameworks/sonnet-${KFMIN}:6
	>=kde-frameworks/syntax-highlighting-${KFMIN}:6
"
DEPEND="${RDEPEND}"
