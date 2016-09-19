# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_TEST="forceoptional-recursive"
VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="Libraries for messaging functions"
LICENSE="GPL-2+ LGPL-2.1+"
KEYWORDS="~amd64 ~x86"
IUSE=""

# drop qtgui subslot operator when QT_MINIMAL >= 5.7.0
COMMON_DEPEND="
	$(add_frameworks_dep karchive)
	$(add_frameworks_dep kcodecs)
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kitemmodels)
	$(add_frameworks_dep kitemviews)
	$(add_frameworks_dep kjobwidgets)
	$(add_frameworks_dep knotifications)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep ktextwidgets)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kwindowsystem)
	$(add_frameworks_dep kxmlgui)
	$(add_frameworks_dep sonnet)
	$(add_kdeapps_dep akonadi)
	$(add_kdeapps_dep akonadi-mime)
	$(add_kdeapps_dep akonadi-notes)
	$(add_kdeapps_dep gpgmepp)
	$(add_kdeapps_dep grantleetheme)
	$(add_kdeapps_dep incidenceeditor)
	$(add_kdeapps_dep kcalcore)
	$(add_kdeapps_dep kcontacts)
	$(add_kdeapps_dep kdepim-apps-libs)
	$(add_kdeapps_dep kidentitymanagement)
	$(add_kdeapps_dep kldap)
	$(add_kdeapps_dep kmailtransport)
	$(add_kdeapps_dep kmbox)
	$(add_kdeapps_dep kmime)
	$(add_kdeapps_dep kpimtextedit)
	$(add_kdeapps_dep libgravatar)
	$(add_kdeapps_dep libkdepim)
	$(add_kdeapps_dep libkleo)
	$(add_qt_dep qtgui '' '' '5=')
	$(add_qt_dep qtnetwork)
	$(add_qt_dep qtprintsupport)
	$(add_qt_dep qtwebengine 'widgets')
	$(add_qt_dep qtwebkit)
	$(add_qt_dep qtwidgets)
	>=dev-libs/grantlee-5.1.0:5
"
DEPEND="${COMMON_DEPEND}
	test? ( $(add_kdeapps_dep akonadi-contacts) )
"
RDEPEND="${COMMON_DEPEND}
	!<kde-apps/kdepim-addons-16.04.50:5
	!kde-apps/kdepim-common-libs:4
"

# bug 579630
RESTRICT="test"
