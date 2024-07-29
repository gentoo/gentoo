# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="forceoptional"
inherit ecm kde.org

DESCRIPTION="Backup scheduler for the Plasma desktop"
HOMEPAGE="https://apps.kde.org/kup/"
SRC_URI="mirror://kde/stable/${PN}/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="5"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	dev-libs/libgit2:=
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	kde-frameworks/kcompletion:5
	kde-frameworks/kconfig:5
	kde-frameworks/kconfigwidgets:5
	kde-frameworks/kcoreaddons:5
	kde-frameworks/kdbusaddons:5
	kde-frameworks/ki18n:5
	kde-frameworks/kidletime:5
	kde-frameworks/kinit:5
	kde-frameworks/kio:5
	kde-frameworks/kjobwidgets:5
	kde-frameworks/knotifications:5
	kde-frameworks/kwidgetsaddons:5
	kde-frameworks/kxmlgui:5
	kde-frameworks/solid:5
	kde-plasma/libplasma:5
"
RDEPEND="${DEPEND}
	dev-qt/qtdeclarative:5
	dev-qt/qtsvg:5
	net-misc/rsync
"
