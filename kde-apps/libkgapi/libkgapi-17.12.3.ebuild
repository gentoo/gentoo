# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_BLOCK_SLOT4="false"
KDE_TEST="true"
VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="Library for accessing Google calendar and contact resources"
HOMEPAGE="https://cgit.kde.org/libkgapi.git"

LICENSE="LGPL-2.1+"
KEYWORDS="~amd64 ~x86"
IUSE="nls"

COMMON_DEPEND="
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kwindowsystem)
	$(add_kdeapps_dep kcalcore)
	$(add_kdeapps_dep kcontacts)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtnetwork)
	$(add_qt_dep qtwebengine 'widgets')
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtxml)
"
DEPEND="${COMMON_DEPEND}
	nls? ( $(add_qt_dep linguist-tools) )
"
RDEPEND="${COMMON_DEPEND}
	!kde-apps/kdepim-l10n
"
