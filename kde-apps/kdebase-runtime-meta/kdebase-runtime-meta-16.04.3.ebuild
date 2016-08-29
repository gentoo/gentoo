# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit kde5-meta-pkg

DESCRIPTION="Merge this to pull in all kdebase-runtime-derived packages"
KEYWORDS="amd64 ~arm x86 ~amd64-linux ~x86-linux"
IUSE="+oldwallet pam +webkit"

RDEPEND="
	$(add_kdeapps_dep kcmshell '' 16.04.3)
	$(add_kdeapps_dep kdebase-data '' 16.04.3)
	$(add_kdeapps_dep kdebase-desktoptheme '' 16.04.3)
	$(add_kdeapps_dep kdebase-menu '' 16.04.3)
	$(add_kdeapps_dep kdebase-menu-icons '' 16.04.3)
	$(add_kdeapps_dep kdebugdialog '' 16.04.3)
	$(add_kdeapps_dep kdesu '-handbook' 16.04.3)
	$(add_kdeapps_dep kdontchangethehostname '' 16.04.3)
	$(add_kdeapps_dep keditfiletype '' 16.04.3)
	$(add_kdeapps_dep kfile '' 16.04.3)
	$(add_kdeapps_dep kiconfinder '' 16.04.3)
	$(add_kdeapps_dep kimgio '' 16.04.3)
	$(add_kdeapps_dep kioclient '' 16.04.3)
	$(add_kdeapps_dep kmimetypefinder '' 16.04.3)
	$(add_kdeapps_dep knewstuff '' 16.04.3)
	$(add_kdeapps_dep knotify '' 16.04.3)
	$(add_kdeapps_dep kpasswdserver '' 16.04.3)
	$(add_kdeapps_dep kquitapp '' 16.04.3)
	$(add_kdeapps_dep kreadconfig '' 16.04.3)
	$(add_kdeapps_dep kstart '' 16.04.3)
	$(add_kdeapps_dep ktimezoned '' 16.04.3)
	$(add_kdeapps_dep ktraderclient '' 16.04.3)
	$(add_kdeapps_dep kurifilter-plugins '' 16.04.3)
	$(add_kdeapps_dep phonon-kde '' 16.04.3)
	$(add_kdeapps_dep renamedlg-plugins '' 16.04.3)
	$(add_kdeapps_dep solid-runtime '-bluetooth' 16.04.3)
	oldwallet? (
		$(add_kdeapps_dep kwalletd '' 16.04.3)
		pam? ( || ( $(add_plasma_dep kwallet-pam 'oldwallet') kde-apps/kwalletd-pam:4 ) )
	)
	webkit? ( $(add_kdeapps_dep plasma-runtime '' 16.04.3) )
"
