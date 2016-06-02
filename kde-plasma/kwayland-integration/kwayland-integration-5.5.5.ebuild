# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit kde5

DESCRIPTION="Provides integration plugins for various KDE frameworks for Wayland"
HOMEPAGE="https://projects.kde.org/projects/kde/workspace/kwayland-integration"

LICENSE="LGPL-2.1"
KEYWORDS="amd64 ~arm x86"
IUSE=""

DEPEND="
	$(add_frameworks_dep kidletime)
	$(add_frameworks_dep kwayland '' 5.5.5)
	$(add_frameworks_dep kwindowsystem)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
"
RDEPEND="${DEPEND}"
