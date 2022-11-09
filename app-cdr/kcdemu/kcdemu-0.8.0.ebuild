# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="kde_cdemu"
KFMIN=5.60.0
QTMIN=5.12.3
inherit ecm

DESCRIPTION="Frontend to cdemu daemon based on KDE Frameworks"
HOMEPAGE="https://www.linux-apps.com/p/998461/"
SRC_URI="mirror://sourceforge/project/kde-cdemu-manager/kde_cdemu-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="5"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kdbusaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/knotifications-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
"
RDEPEND="${DEPEND}
	>=app-cdr/cdemu-2.0.0[cdemu-daemon]
"

S="${WORKDIR}/${MY_PN}"
