# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit kde4-meta-pkg

DESCRIPTION="Merge this to pull in all kdebase-derived packages"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="+display-manager minimal +wallpapers"

RDEPEND="
	$(add_kdeapps_dep dolphin)
	$(add_kdeapps_dep kde-base-artwork)
	$(add_kdeapps_dep kdebase-runtime-meta)
	$(add_kdeapps_dep kdialog)
	$(add_kdeapps_dep keditbookmarks)
	$(add_kdeapps_dep kfind)
	$(add_kdeapps_dep kfmclient)
	$(add_kdeapps_dep konq-plugins)
	$(add_kdeapps_dep konqueror)
	$(add_kdeapps_dep konsolepart)
	$(add_kdeapps_dep konsole)
	$(add_kdeapps_dep kwrite)
	$(add_kdeapps_dep libkonq)
	$(add_kdeapps_dep nsplugins)
	$(add_kdeapps_dep phonon-kde)
	wallpapers? ( || ( $(add_kdeapps_dep kde-wallpapers) kde-apps/kde-wallpapers:5 ) )
	!minimal? (
		$(add_kdebase_dep freespacenotifier '' 4.11)
		$(add_kdebase_dep kcheckpass '' 4.11.22-r1)
		$(add_kdebase_dep kcminit '' 4.11)
		$(add_kdebase_dep kdebase-cursors '' 4.11)
		$(add_kdebase_dep kdebase-startkde '' 4.11)
		$(add_kdeapps_dep kdepasswd)
		$(add_kdebase_dep kephal '' 4.11)
		$(add_kdebase_dep khotkeys '' 4.11)
		$(add_kdebase_dep kinfocenter '' 4.11)
		$(add_kdebase_dep klipper '' 4.11)
		$(add_kdebase_dep kmenuedit '' 4.11)
		$(add_kdebase_dep krunner '' 4.11)
		$(add_kdebase_dep kscreensaver '' 4.11)
		$(add_kdebase_dep ksmserver '' 4.11)
		$(add_kdebase_dep ksplash '' 4.11)
		$(add_kdebase_dep kstartupconfig '' 4.11)
		$(add_kdebase_dep kstyles '' 4.11)
		$(add_kdebase_dep ksysguard '' 4.11)
		$(add_kdebase_dep ksystraycmd '' 4.11)
		$(add_kdebase_dep kwin '' 4.11)
		$(add_kdebase_dep kwrited '' 4.11)
		$(add_kdebase_dep libkworkspace '' 4.11)
		$(add_kdebase_dep liboxygenstyle '' 4.11)
		$(add_kdebase_dep libplasmaclock '' 4.11)
		$(add_kdebase_dep libplasmagenericshell '' 4.11)
		$(add_kdebase_dep libtaskmanager '' 4.11)
		$(add_kdeapps_dep plasma-apps)
		$(add_kdebase_dep plasma-workspace '' 4.11)
		$(add_kdebase_dep powerdevil '' 4.11)
		$(add_kdebase_dep qguiplatformplugin_kde '' 4.11)
		$(add_kdebase_dep solid-actions-kcm '' 4.11)
		$(add_kdebase_dep systemsettings '' 4.11)
		!prefix? ( display-manager? ( || ( $(add_kdebase_dep kdm '' 4.11) x11-misc/lightdm x11-misc/sddm ) ) )
	)
"
