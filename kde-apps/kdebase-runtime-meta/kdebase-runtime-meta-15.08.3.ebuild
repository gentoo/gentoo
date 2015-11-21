# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit kde5-meta-pkg

DESCRIPTION="Merge this to pull in all kdebase-runtime-derived packages"
KEYWORDS=" ~amd64 ~x86"
IUSE="crash-reporter minimal +oldwallet"

RDEPEND="
	$(add_kdeapps_dep kcmshell)
	$(add_kdeapps_dep kdebase-data)
	$(add_kdeapps_dep kdebase-desktoptheme)
	$(add_kdeapps_dep kdebase-menu)
	$(add_kdeapps_dep kdebase-menu-icons)
	$(add_kdeapps_dep kdebugdialog)
	$(add_kdeapps_dep kdesu)
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
	$(add_kdeapps_dep solid-runtime)
	crash-reporter? ( $(add_kdeapps_dep drkonqi ) )
	minimal? (
		$(add_kdeapps_dep solid-runtime '-bluetooth')
		oldwallet? ( $(add_kdeapps_dep kwalletd) )
	)
	!minimal? (
		$(add_kdeapps_dep attica)
		$(add_kdeapps_dep kcontrol)
		$(add_kdeapps_dep kdebase-kioslaves)
		$(add_kdeapps_dep kglobalaccel)
		$(add_kdeapps_dep knetattach)
		$(add_kdeapps_dep kuiserver)
		$(add_kdeapps_dep kwalletd)
	)
"
REQUIRED_USE="minimal? ( !crash-reporter )"
