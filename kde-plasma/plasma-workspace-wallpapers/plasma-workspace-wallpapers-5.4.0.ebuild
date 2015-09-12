# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_AUTODEPS="false"
KDE_DEBUG="false"
KDE_SCM="svn"
inherit kde5

DESCRIPTION="Additional wallpapers for the Plasma workspace"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	!kde-base/plasma-workspace-wallpapers
"
DEPEND="${RDEPEND}
	$(add_frameworks_dep extra-cmake-modules)
"
