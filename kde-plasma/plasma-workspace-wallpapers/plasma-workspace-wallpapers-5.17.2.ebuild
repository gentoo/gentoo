# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_AUTODEPS="false"
KDE_DEBUG="false"
inherit kde5

DESCRIPTION="Wallpapers for the Plasma workspace"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
IUSE=""

BDEPEND="
	$(add_frameworks_dep extra-cmake-modules)
	$(add_qt_dep qtcore)
"
