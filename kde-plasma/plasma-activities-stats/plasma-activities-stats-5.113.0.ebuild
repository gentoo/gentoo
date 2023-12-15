# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_NONGUI="true"
ECM_QTHELP="true"
ECM_TEST="true"
KDE_ORG_TAR_PN="kactivities-stats"
KFMIN=$(ver_cut 1-2)
QTMIN=5.15.9
inherit ecm frameworks.kde.org

DESCRIPTION="Library for accessing usage data collected by the activities system"

LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE=""

RDEPEND="
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtsql-${QTMIN}:5
	=kde-frameworks/kconfig-${KFMIN}*:5
	=kde-plasma/plasma-activities-${KFMIN}*:5
"
DEPEND="${RDEPEND}
	test? ( dev-libs/boost )
"
