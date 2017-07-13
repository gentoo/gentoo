# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit kde5-meta-pkg

DESCRIPTION="kdeutils - merge this to pull in all kdeutils-derived packages"
HOMEPAGE="https://www.kde.org/applications/utilities https://utils.kde.org"
KEYWORDS="~amd64 ~x86"
IUSE="cups floppy lirc nls"

[[ ${KDE_BUILD_TYPE} = live ]] && L10N_MINIMAL=${KDE_APPS_MINIMAL}

RDEPEND="
	$(add_kdeapps_dep ark)
	$(add_kdeapps_dep filelight)
	$(add_kdeapps_dep kcalc)
	$(add_kdeapps_dep kcharselect)
	$(add_kdeapps_dep kdebugsettings)
	$(add_kdeapps_dep kdf)
	$(add_kdeapps_dep kgpg)
	$(add_kdeapps_dep kteatime)
	$(add_kdeapps_dep ktimer)
	$(add_kdeapps_dep kwalletmanager)
	$(add_kdeapps_dep sweeper)
	cups? ( $(add_kdeapps_dep print-manager) )
	floppy? ( $(add_kdeapps_dep kfloppy) )
	lirc? ( $(add_kdeapps_dep kremotecontrol) )
	nls? ( $(add_kdeapps_dep kde4-l10n '' ${L10N_MINIMAL}) )
"
