# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit kde5-functions

DESCRIPTION="Merge this to pull in all Plasma 5 packages"
HOMEPAGE="http://www.kde.org/workspaces/plasmadesktop/"

LICENSE="metapackage"
SLOT="5"
KEYWORDS="~amd64"
IUSE="bluetooth +display-manager gtk +sddm networkmanager +wallpapers"

RDEPEND="
	$(add_plasma_dep breeze)
	$(add_plasma_dep kde-cli-tools)
	$(add_plasma_dep kdecoration)
	$(add_plasma_dep kdeplasma-addons)
	$(add_plasma_dep khelpcenter)
	$(add_plasma_dep khotkeys)
	$(add_plasma_dep kinfocenter)
	$(add_plasma_dep kmenuedit)
	$(add_plasma_dep kscreen)
	$(add_plasma_dep ksshaskpass)
	$(add_plasma_dep ksysguard)
	$(add_plasma_dep kwayland)
	$(add_plasma_dep kwin)
	$(add_plasma_dep kwrited)
	$(add_plasma_dep libkscreen)
	$(add_plasma_dep milou)
	$(add_plasma_dep oxygen)
	$(add_plasma_dep oxygen-fonts)
	$(add_plasma_dep plasma-desktop)
	$(add_plasma_dep plasma-mediacenter)
	$(add_plasma_dep plasma-sdk)
	$(add_plasma_dep plasma-workspace)
	$(add_plasma_dep polkit-kde-agent)
	$(add_plasma_dep powerdevil)
	$(add_plasma_dep systemsettings)
	bluetooth? (
		$(add_plasma_dep bluedevil)
	)
	display-manager? (
		sddm? ( x11-misc/sddm )
		!sddm? ( x11-misc/lightdm )
	)
	gtk? ( $(add_plasma_dep kde-gtk-config) )
	networkmanager? ( $(add_plasma_dep plasma-nm) )
	sddm? ( $(add_plasma_dep sddm-kcm) )
	wallpapers? ( $(add_plasma_dep plasma-workspace-wallpapers) )
"
