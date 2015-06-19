# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-plasma/plasma-workspace-wallpapers/plasma-workspace-wallpapers-5.3.1.ebuild,v 1.1 2015/05/31 22:06:17 johu Exp $

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
