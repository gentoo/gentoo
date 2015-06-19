# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-apps/kdenetwork-meta/kdenetwork-meta-4.14.3.ebuild,v 1.1 2015/06/04 18:44:43 kensington Exp $

EAPI=5

inherit kde4-meta-pkg

DESCRIPTION="kdenetwork - merge this to pull in all kdenetwork-derived packages"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="ppp"

RDEPEND="
	$(add_kdeapps_dep kdenetwork-filesharing)
	$(add_kdeapps_dep kget)
	$(add_kdeapps_dep kopete)
	$(add_kdeapps_dep krdc)
	$(add_kdeapps_dep krfb)
	$(add_kdeapps_dep zeroconf-ioslave)
	ppp? ( $(add_kdeapps_dep kppp) )
"
