# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit kde5-meta-pkg

DESCRIPTION="kdeutils - merge this to pull in all kdeutils-derived packages"
HOMEPAGE="https://www.kde.org/applications/utilities https://utils.kde.org"
KEYWORDS=" ~amd64 ~x86"
IUSE="cups floppy lirc"

# FIXME: Add back when ported
# $(add_kdeapps_dep kgpg)
RDEPEND="
	$(add_kdeapps_dep ark)
	$(add_kdeapps_dep filelight)
	$(add_kdeapps_dep kcalc)
	$(add_kdeapps_dep kcharselect)
	$(add_kdeapps_dep kdf)
	$(add_kdeapps_dep kteatime)
	$(add_kdeapps_dep ktimer)
	$(add_kdeapps_dep kwalletmanager)
	$(add_kdeapps_dep superkaramba)
	$(add_kdeapps_dep sweeper)
	cups? ( $(add_kdeapps_dep print-manager) )
	floppy? ( $(add_kdeapps_dep kfloppy) )
	lirc? ( $(add_kdeapps_dep kremotecontrol) )
"
