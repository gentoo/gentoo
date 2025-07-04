# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="forceoptional"
KFMIN=6.13.0
QTMIN=6.7.2
inherit ecm gear.kde.org

DESCRIPTION="Widget library for baloo"

LICENSE="LGPL-2+ LGPL-2.1+ || ( LGPL-2.1 LGPL-3 )"
SLOT="6"
KEYWORDS="amd64 arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE=""

RESTRICT="test"

RDEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[gui,widgets]
	>=kde-frameworks/baloo-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kfilemetadata-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
"
DEPEND="${RDEPEND}
	>=kde-frameworks/kservice-${KFMIN}:6
"
