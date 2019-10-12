# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_TEST="true"
VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="Library for accessing Google calendar and contact resources"
HOMEPAGE="https://cgit.kde.org/libkgapi.git"

LICENSE="LGPL-2.1+"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="nls"

BDEPEND="
	nls? ( $(add_qt_dep linguist-tools) )
"
DEPEND="
	$(add_frameworks_dep kcalendarcore)
	$(add_frameworks_dep kcontacts)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kwindowsystem)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtnetwork)
	$(add_qt_dep qtwebengine 'widgets')
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtxml)
	dev-libs/cyrus-sasl:2
"
RDEPEND="${DEPEND}
	!kde-apps/kdepim-l10n
	!<kde-apps/kdepim-runtime-18.07.80:5
"
