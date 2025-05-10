# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_QTHELP="true"
ECM_TEST="true"
PVCUT=$(ver_cut 1-3)
KFMIN=6.13.0
QTMIN=6.7.2
inherit ecm gear.kde.org

DESCRIPTION="Library providing utility functions for the handling of calendar data"
HOMEPAGE="https://api.kde.org/kdepim/kcalutils/html/index.html"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="6"
KEYWORDS="~amd64 ~arm64"
IUSE=""

RESTRICT="test" # bugs 653616, 711666

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[gui,widgets]
	>=kde-apps/kidentitymanagement-${PVCUT}:6
	>=kde-frameworks/kcalendarcore-${KFMIN}:6
	>=kde-frameworks/kcodecs-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kiconthemes-${KFMIN}:6
	>=kde-frameworks/ktexttemplate-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
"
RDEPEND="${DEPEND}"
