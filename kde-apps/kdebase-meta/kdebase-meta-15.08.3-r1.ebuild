# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit kde5-meta-pkg

DESCRIPTION="Transitional package to pull in plasma-meta plus basic applications"
KEYWORDS="~amd64 ~x86"
IUSE="+display-manager minimal +wallpapers"

RDEPEND="
	$(add_kdeapps_dep dolphin)
	$(add_kdeapps_dep konsole)
	$(add_kdeapps_dep kwrite)
	$(add_plasma_dep plasma-meta)
	wallpapers? ( $(add_kdeapps_dep kde-wallpapers) )
	!minimal? ( $(add_kdeapps_dep kdebase-runtime-meta 'minimal') )
	!prefix? ( display-manager? ( || ( x11-misc/lightdm x11-misc/sddm ) ) )
"
