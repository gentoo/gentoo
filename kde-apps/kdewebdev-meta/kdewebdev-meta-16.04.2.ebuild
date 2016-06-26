# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit kde5-meta-pkg

DESCRIPTION="KDE WebDev - merge this to pull in all kdewebdev-derived packages"
KEYWORDS="~amd64 ~x86"
IUSE=""

# FIXME: Add back when ported
# $(add_kdeapps_dep klinkstatus)
RDEPEND="
	$(add_kdeapps_dep kfilereplace)
	$(add_kdeapps_dep kimagemapeditor)
	$(add_kdeapps_dep kommander)
"
