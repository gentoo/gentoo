# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_NONGUI="true"
ECM_QTHELP="true"
ECM_TEST="true"
KFMIN=6.6.0
QTMIN=6.7.2
inherit ecm plasma.kde.org

DESCRIPTION="Library for accessing usage data collected by the activities system"

LICENSE="LGPL-2+"
SLOT="6"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE=""

RDEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus,sql]
	>=kde-frameworks/kconfig-${KFMIN}:6
	kde-plasma/plasma-activities:6
"
DEPEND="${RDEPEND}
	test? ( dev-libs/boost )
"
