# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_TEST="forceoptional"
VIRTUALDBUS_TEST="true"
KFMIN=5.60.0
PLASMA_MINIMAL=5.16.5
QTMIN=5.12.3
inherit ecm kde.org

DESCRIPTION="Administer web accounts for the sites and services across the Plasma desktop"
HOMEPAGE="https://community.kde.org/KTp"
LICENSE="LGPL-2.1"

SLOT="5"
KEYWORDS="~arm arm64"
IUSE=""

BDEPEND="
	sys-devel/gettext
"
COMMON_DEPEND="
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kdbusaddons-${KFMIN}:5
	>=kde-frameworks/kdeclarative-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	net-libs/accounts-qt
	>=net-libs/libaccounts-glib-1.21:=
	net-libs/signond
"
DEPEND="${COMMON_DEPEND}
	>=kde-frameworks/kcmutils-${KFMIN}:5
	>=kde-plasma/kde-cli-tools-${PLASMA_MINIMAL}:5
"
RDEPEND="${COMMON_DEPEND}
	dev-util/intltool
"

# bug #549444
RESTRICT+=" test"
