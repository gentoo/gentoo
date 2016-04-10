# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit kde5-meta-pkg

DESCRIPTION="Merge this to pull in all kdebase-runtime-derived packages"
KEYWORDS=" ~amd64 ~x86"
IUSE="+oldwallet pam"

RDEPEND="
	$(add_kdeapps_dep kcmshell)
	$(add_kdeapps_dep kdebase-data)
	$(add_kdeapps_dep kdebase-desktoptheme)
	$(add_kdeapps_dep kdebase-menu)
	$(add_kdeapps_dep kdebase-menu-icons)
	$(add_kdeapps_dep kdebugdialog)
	$(add_kdeapps_dep kdesu '-handbook')
	$(add_kdeapps_dep kdontchangethehostname)
	$(add_kdeapps_dep keditfiletype)
	$(add_kdeapps_dep kfile)
	$(add_kdeapps_dep kiconfinder)
	$(add_kdeapps_dep kimgio)
	$(add_kdeapps_dep kioclient)
	$(add_kdeapps_dep kmimetypefinder)
	$(add_kdeapps_dep knewstuff)
	$(add_kdeapps_dep knotify)
	$(add_kdeapps_dep kpasswdserver)
	$(add_kdeapps_dep kquitapp)
	$(add_kdeapps_dep kreadconfig)
	$(add_kdeapps_dep kstart)
	$(add_kdeapps_dep ktimezoned)
	$(add_kdeapps_dep ktraderclient)
	$(add_kdeapps_dep kurifilter-plugins)
	$(add_kdeapps_dep phonon-kde)
	$(add_kdeapps_dep plasma-runtime)
	$(add_kdeapps_dep renamedlg-plugins)
	$(add_kdeapps_dep solid-runtime '-bluetooth')
	oldwallet? (
		$(add_kdeapps_dep kwalletd)
		pam? ( || ( kde-apps/kwalletd-pam:4 $(add_plasma_dep kwallet-pam 'oldwallet') ) )
	)
"
