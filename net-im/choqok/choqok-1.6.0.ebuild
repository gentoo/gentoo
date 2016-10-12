# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_HANDBOOK="forceoptional"
inherit kde5

DESCRIPTION="Free/Open Source micro-blogging client by KDE"
HOMEPAGE="http://choqok.gnufolks.org/"
[[ ${KDE_BUILD_TYPE} != live ]] && SRC_URI="mirror://kde/stable/${PN}/${PV%.0}/src/${P}.tar.xz"

LICENSE="GPL-2+"
KEYWORDS="~amd64 ~x86"
IUSE="attica konqueror telepathy"
#qtnetwork
DEPEND="
	$(add_frameworks_dep kcmutils)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kemoticons)
	$(add_frameworks_dep kglobalaccel)
	$(add_frameworks_dep kguiaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kjobwidgets)
	$(add_frameworks_dep knotifications)
	$(add_frameworks_dep knotifyconfig)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep ktextwidgets)
	$(add_frameworks_dep kwallet)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kxmlgui)
	$(add_frameworks_dep sonnet)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtxml)
	app-crypt/qca[qt5]
	dev-libs/qoauth:5
	attica? ( $(add_frameworks_dep attica) )
	konqueror? (
		$(add_frameworks_dep kparts)
		$(add_frameworks_dep kdewebkit)
		$(add_qt_dep qtwebkit)
	)
	telepathy? ( net-libs/telepathy-qt[qt5] )
"
RDEPEND="${DEPEND}
	!net-im/choqok:4
"

DOCS=( AUTHORS README TODO changelog )

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package attica KF5Attica)
		$(cmake-utils_use_find_package konqueror KF5Parts)
		$(cmake-utils_use_find_package konqueror KF5WebKit)
		$(cmake-utils_use_find_package telepathy TelepathyQt5)
	)

	kde5_src_configure
}
