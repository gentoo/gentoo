# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit kde4-meta-pkg

DESCRIPTION="kdeartwork - merge this to pull in all kdeartwork-derived packages"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="minimal"

RDEPEND="
	$(add_kdeapps_dep kdeartwork-colorschemes)
	$(add_kdeapps_dep kdeartwork-desktopthemes)
	$(add_kdeapps_dep kdeartwork-emoticons)
	$(add_kdeapps_dep kdeartwork-iconthemes)
	$(add_kdeapps_dep kdeartwork-kscreensaver)
	$(add_kdeapps_dep kdeartwork-wallpapers)
	$(add_kdeapps_dep kdeartwork-weatherwallpapers)
	!minimal? ( $(add_kdeapps_dep kdeartwork-styles) )
"
