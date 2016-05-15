# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_DOXYGEN="true"
KDE_TEST="true"
inherit kde5

DESCRIPTION="Framework providing client-side support for the XML-RPC protocol"
LICENSE="BSD-2"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

RDEPEND="
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kio)
	$(add_qt_dep qtxml)
	!<kde-plasma/plasma-workspace-5.2.95
"
DEPEND="${RDEPEND}"
