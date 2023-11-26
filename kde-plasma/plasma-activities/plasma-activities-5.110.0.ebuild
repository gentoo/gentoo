# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_NONGUI="true"
ECM_QTHELP="true"
ECM_TEST="true"
KDE_ORG_NAME="kactivities"
KFMIN=$(ver_cut 1-2)
QTMIN=5.15.9
inherit ecm frameworks.kde.org

DESCRIPTION="Core components for KDE's Activities System"

LICENSE="|| ( LGPL-2.1 LGPL-3 )"
KEYWORDS="amd64 ~arm arm64 ~loong ~ppc64 ~riscv x86"
IUSE=""

COMMON_DEPEND="
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtdeclarative-${QTMIN}:5[widgets]
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtsql-${QTMIN}:5
	=kde-frameworks/kconfig-${KFMIN}*:5
	=kde-frameworks/kcoreaddons-${KFMIN}*:5
"
RDEPEND="${COMMON_DEPEND}
	>=kde-plasma/kactivitymanagerd-5.16.5:5
"
DEPEND="${COMMON_DEPEND}
	dev-libs/boost
"
