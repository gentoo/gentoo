# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_TEST="forceoptional"
VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="Plugin based library to create window decorations"
LICENSE="|| ( LGPL-2.1 LGPL-3 )"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE=""

DEPEND="
	$(add_frameworks_dep ki18n)
	$(add_qt_dep qtgui)
"
RDEPEND="${DEPEND}"
