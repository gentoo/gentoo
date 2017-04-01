# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit kde5-meta-pkg

DESCRIPTION="Merge this to pull in all kdebase-runtime-derived packages"
KEYWORDS="amd64 ~arm x86 ~amd64-linux ~x86-linux"
IUSE="kwallet nls pam"

[[ ${KDE_BUILD_TYPE} = live ]] && L10N_MINIMAL=${KDE_APPS_MINIMAL}

RDEPEND="
	$(add_kdeapps_dep kcmshell '' 16.04.3)
	$(add_kdeapps_dep kdebase-data '' 16.04.3)
	$(add_kdeapps_dep kdontchangethehostname '' 16.04.3)
	$(add_kdeapps_dep keditfiletype '' 16.04.3)
	$(add_kdeapps_dep kfile '' 16.04.3)
	$(add_kdeapps_dep kioclient '' 16.04.3)
	$(add_kdeapps_dep kmimetypefinder '' 16.04.3)
	$(add_kdeapps_dep knewstuff '' 16.04.3)
	$(add_kdeapps_dep kreadconfig '' 16.04.3)
	$(add_kdeapps_dep ktimezoned '' 16.04.3)
	$(add_kdeapps_dep ktraderclient '' 16.04.3)
	$(add_kdeapps_dep phonon-kde '' 16.04.3)
	kwallet? (
		$(add_kdeapps_dep kwalletd '' 16.04.3)
		pam? ( $(add_plasma_dep kwallet-pam 'oldwallet') )
	)
	nls? ( $(add_kdeapps_dep kde4-l10n '' ${L10N_MINIMAL}) )
"
