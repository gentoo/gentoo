# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit kde5-meta-pkg

DESCRIPTION="kdecore - merge this to pull in the most basic applications"
KEYWORDS="~amd64 ~x86"
IUSE="+handbook minimal"

RDEPEND="
	$(add_kdeapps_dep dolphin)
	$(add_kdeapps_dep konsole)
	$(add_kdeapps_dep kwrite)
	handbook? ( $(add_kdeapps_dep khelpcenter) )
	!minimal? ( $(add_kdeapps_dep kdebase-runtime-meta '' 16.04.3) )
"
