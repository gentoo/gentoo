# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit kde4-base

DESCRIPTION="KDE: screensaver featuring the Space-Faring Tux"
HOMEPAGE+=" https://userbase.kde.org/KTux"
KEYWORDS=" ~amd64 ~x86"
IUSE="debug"

# libkworkspace - only as a stub to provide KDE4Workspace config
DEPEND="
	$(add_kdebase_dep kscreensaver '' 4.11)
	$(add_kdebase_dep libkworkspace '' 4.11)
"
RDEPEND="${DEPEND}"
