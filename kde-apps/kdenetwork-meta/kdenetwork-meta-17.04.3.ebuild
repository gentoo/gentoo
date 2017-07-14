# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit kde5-meta-pkg

DESCRIPTION="kdenetwork - merge this to pull in all kdenetwork-derived packages"
KEYWORDS="~amd64 ~x86"
IUSE="nls ppp"

[[ ${KDE_BUILD_TYPE} = live ]] && L10N_MINIMAL=${KDE_APPS_MINIMAL}

# FIXME: Add back whenever it gets ported
# $(add_kdeapps_dep kopete)
RDEPEND="
	$(add_kdeapps_dep kdenetwork-filesharing)
	$(add_kdeapps_dep kget)
	$(add_kdeapps_dep krdc)
	$(add_kdeapps_dep krfb)
	$(add_kdeapps_dep plasma-telepathy-meta)
	$(add_kdeapps_dep zeroconf-ioslave)
	nls? ( $(add_kdeapps_dep kde4-l10n '' ${L10N_MINIMAL}) )
	ppp? ( $(add_kdeapps_dep kppp) )
"
