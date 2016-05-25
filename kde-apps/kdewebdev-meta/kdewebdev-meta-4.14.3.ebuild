# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit kde4-meta-pkg

DESCRIPTION="KDE WebDev - merge this to pull in all kdewebdev-derived packages"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	$(add_kdeapps_dep kfilereplace)
	$(add_kdeapps_dep kimagemapeditor)
	$(add_kdeapps_dep klinkstatus)
	$(add_kdeapps_dep kommander)
"
