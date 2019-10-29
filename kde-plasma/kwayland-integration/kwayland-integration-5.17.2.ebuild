# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_TEST="true"
inherit kde5

DESCRIPTION="Provides integration plugins for various KDE frameworks for Wayland"
HOMEPAGE="https://cgit.kde.org/kwayland-integration.git"

LICENSE="LGPL-2.1"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE=""

DEPEND="
	$(add_frameworks_dep kguiaddons)
	$(add_frameworks_dep kidletime)
	$(add_frameworks_dep kwayland)
	$(add_frameworks_dep kwindowsystem)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
"
RDEPEND="${DEPEND}"

RESTRICT+=" test" # bug 668872
