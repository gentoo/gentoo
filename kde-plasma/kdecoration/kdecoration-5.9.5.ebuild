# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_GCC_MINIMAL="4.8"
KDE_TEST="forceoptional"
VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="Plugin based library to create window decorations"
LICENSE="|| ( LGPL-2.1 LGPL-3 )"
KEYWORDS="amd64 ~arm x86"
IUSE=""

DEPEND="$(add_qt_dep qtgui)"
RDEPEND="${DEPEND}"
