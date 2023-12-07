# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="forceoptional"
KFMIN=5.106.0
QTMIN=5.15.9
VIRTUALDBUS_TEST="true"
inherit ecm gear.kde.org

DESCRIPTION="Administer web accounts for the sites and services across the Plasma desktop"
HOMEPAGE="https://community.kde.org/KTp"

LICENSE="LGPL-2.1"
SLOT="5"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE=""

# bug #549444
RESTRICT="test"

COMMON_DEPEND="
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kdbusaddons-${KFMIN}:5
	>=kde-frameworks/kdeclarative-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kwallet-${KFMIN}:5
	net-libs/accounts-qt[qt5(+)]
	net-libs/signond[qt5(+)]
"
DEPEND="${COMMON_DEPEND}
	dev-libs/qcoro5
	>=kde-frameworks/kcmutils-${KFMIN}:5
	kde-plasma/kde-cli-tools:*
"
# KAccountsMacros.cmake needs intltool
RDEPEND="${COMMON_DEPEND}
	dev-util/intltool
"
BDEPEND="
	>=kde-frameworks/kpackage-${KFMIN}:5
	sys-devel/gettext
"
