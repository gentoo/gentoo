# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_TEST="forceoptional"
VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="Getting things done application by KDE"
HOMEPAGE="https://zanshin.kde.org/"
SRC_URI="mirror://kde/stable/${PN}/${P}.tar.xz"

LICENSE="|| ( GPL-2 GPL-3 )"
KEYWORDS="amd64 x86"
IUSE=""

BDEPEND="
	test? ( <kde-apps/akonadi-19.04.50:5[tools] )
"
COMMON_DEPEND="
	$(add_frameworks_dep kcodecs)
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kdelibs4support)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kitemmodels)
	$(add_frameworks_dep kitemviews)
	$(add_frameworks_dep kjobwidgets)
	$(add_frameworks_dep kparts)
	$(add_frameworks_dep krunner)
	$(add_frameworks_dep kwallet)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kwindowsystem)
	$(add_frameworks_dep kxmlgui)
	<kde-apps/akonadi-19.04.50:5
	<kde-apps/akonadi-calendar-19.04.50:5
	<kde-apps/akonadi-contacts-19.04.50:5
	<kde-apps/akonadi-notes-19.04.50:5
	<kde-apps/akonadi-search-19.04.50:5
	<kde-apps/kcalcore-19.04.50:5
	<kde-apps/kcontacts-19.04.50:5
	<kde-apps/kidentitymanagement-19.04.50:5
	<kde-apps/kldap-19.04.50:5
	<kde-apps/kmime-19.04.50:5
	<kde-apps/kontactinterface-19.04.50:5
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtdeclarative)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtnetwork)
	$(add_qt_dep qtwidgets)
"
DEPEND="${COMMON_DEPEND}
	dev-libs/boost
"
RDEPEND="${COMMON_DEPEND}
	!kde-misc/zanshin:4
	<kde-apps/kdepim-runtime-19.04.50:5
"

PATCHES=( "${FILESDIR}/${P}-cmake.patch" )
