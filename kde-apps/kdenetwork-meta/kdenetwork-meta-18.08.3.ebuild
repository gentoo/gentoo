# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit kde5-meta-pkg

DESCRIPTION="kdenetwork - merge this to pull in all kdenetwork-derived packages"
KEYWORDS="~amd64 ~x86"
IUSE="+telepathy"

RDEPEND="
	$(add_kdeapps_dep kdenetwork-filesharing)
	$(add_kdeapps_dep kget)
	$(add_kdeapps_dep krdc)
	$(add_kdeapps_dep kopete)
	$(add_kdeapps_dep krfb)
	$(add_kdeapps_dep zeroconf-ioslave)
	telepathy? ( $(add_kdeapps_dep plasma-telepathy-meta) )
"
