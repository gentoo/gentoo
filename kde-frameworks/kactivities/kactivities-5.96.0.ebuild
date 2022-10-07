# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PVCUT=$(ver_cut 1-2)
PLASMA_MINIMAL=5.16.5
QTMIN=5.15.4
inherit ecm frameworks.kde.org

DESCRIPTION="Framework for working with KDE activities"
LICENSE="|| ( LGPL-2.1 LGPL-3 )"
KEYWORDS="amd64 ~arm arm64 ~loong ~ppc64 ~riscv x86"
IUSE=""

COMMON_DEPEND="
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtdeclarative-${QTMIN}:5[widgets]
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtsql-${QTMIN}:5
	=kde-frameworks/kconfig-${PVCUT}*:5
	=kde-frameworks/kcoreaddons-${PVCUT}*:5
"
RDEPEND="${COMMON_DEPEND}
	>=kde-plasma/kactivitymanagerd-${PLASMA_MINIMAL}:5
"
DEPEND="${COMMON_DEPEND}
	dev-libs/boost
"
