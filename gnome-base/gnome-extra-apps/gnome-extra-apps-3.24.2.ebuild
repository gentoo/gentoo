# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Sub-meta package for the applications of GNOME 3"
HOMEPAGE="https://www.gnome.org/"
LICENSE="metapackage"
SLOT="3.0"
IUSE="+games +share +shotwell +tracker"

KEYWORDS="amd64 x86"

# Note to developers:
# This is a wrapper for the extra apps integrated with GNOME 3
# Keep pkg order within a USE flag as upstream releng versions file
# TODO: Should we keep these here: gnome-power-manager, gucharmap, sound-juicer; replace gucharmap with gnome-characters?
RDEPEND="
	>=gnome-base/gnome-core-libs-${PV}

	>=sys-apps/baobab-3.24.0
	>=media-video/cheese-3.24.0
	>=www-client/epiphany-${PV}
	>=app-arch/file-roller-3.24.1
	>=gnome-extra/gnome-calculator-3.24.0
	>=gnome-extra/gnome-calendar-${PV}
	>=gnome-extra/gnome-characters-3.24.0
	>=sys-apps/gnome-disk-utility-3.24.1
	>=media-gfx/gnome-font-viewer-3.24.0
	>=gnome-extra/gnome-power-manager-3.24.0
	>=media-gfx/gnome-screenshot-3.22.0
	>=gnome-extra/gnome-system-monitor-3.24.0
	>=gnome-extra/gnome-weather-3.24.0
	>=gnome-extra/gucharmap-9.0.4:2.90
	>=gnome-extra/sushi-3.24.0
	>=media-sound/sound-juicer-3.24.0
	>=net-misc/vino-3.22.0

	>=gnome-base/dconf-editor-${PV}
	>=app-dicts/gnome-dictionary-3.24.1
	>=mail-client/evolution-${PV}
	>=net-analyzer/gnome-nettool-3.8.1
	>=gnome-extra/gnome-tweak-tool-3.24.1
	>=gnome-extra/nautilus-sendto-3.8.4
	>=net-misc/vinagre-3.22.0

	games? (
		>=games-puzzle/five-or-more-3.22.2
		>=games-board/four-in-a-row-3.22.1
		>=games-board/gnome-chess-3.24.1
		>=games-puzzle/gnome-klotski-3.22.1
		>=games-board/gnome-mahjongg-3.22.0
		>=games-board/gnome-mines-3.24.0
		>=games-arcade/gnome-nibbles-3.24.0
		>=games-arcade/gnome-robots-3.22.1
		>=games-puzzle/gnome-sudoku-3.24.0
		>=games-puzzle/gnome-taquin-3.22.0
		>=games-puzzle/gnome-tetravex-3.22.0
		>=games-puzzle/hitori-3.22.3
		>=games-board/iagno-3.22.0
		>=games-puzzle/lightsoff-3.24.0
		>=games-puzzle/quadrapassel-3.22.0
		>=games-puzzle/swell-foop-3.24.0
		>=games-board/tali-3.22.0
	)
	share? ( >=gnome-extra/gnome-user-share-3.18.3 )
	shotwell? ( >=media-gfx/shotwell-0.24 )
	tracker? (
		>=app-misc/tracker-1.12
		>=gnome-extra/gnome-documents-${PV}
		>=media-gfx/gnome-photos-${PV}
		>=media-sound/gnome-music-${PV} )
"
DEPEND=""
S=${WORKDIR}
