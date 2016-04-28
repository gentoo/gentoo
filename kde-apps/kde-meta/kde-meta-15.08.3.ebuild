# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit kde5-meta-pkg

DESCRIPTION="Merge this to pull in all KDE Plasma and Applications packages"
KEYWORDS=" ~amd64 ~x86"
IUSE=""

RDEPEND="
	$(add_kdeapps_dep kde-apps-meta)
	$(add_plasma_dep plasma-meta)
"
