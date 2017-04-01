# Copyright 1999-2017 Gentoo Foundation
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
# TODO: Should we keep these here: gnome-power-manager, gucharmap, sound-juicer
RDEPEND="
	>=gnome-base/gnome-core-libs-${PV}

	>=sys-apps/baobab-3.22.1
	>=media-video/cheese-3.22.1
	>=www-client/epiphany-3.22.2
	>=app-arch/file-roller-3.22.1
	>=gnome-extra/gnome-calculator-${PV}
	>=gnome-extra/gnome-calendar-3.22.1
	>=gnome-extra/gnome-characters-3.22.0
	>=sys-apps/gnome-disk-utility-3.22.1
	>=media-gfx/gnome-font-viewer-3.22.0
	>=gnome-extra/gnome-power-manager-${PV}
	>=media-gfx/gnome-screenshot-3.22.0
	>=gnome-extra/gnome-system-monitor-${PV}
	>=gnome-extra/gnome-weather-3.20.2
	>=gnome-extra/gucharmap-9.0.2:2.90
	>=gnome-extra/sushi-3.21.91
	>=media-sound/sound-juicer-3.22.1
	>=net-misc/vino-3.22.0

	>=gnome-base/dconf-editor-3.22.1
	>=app-dicts/gnome-dictionary-3.20.0
	>=mail-client/evolution-${PV}
	>=net-analyzer/gnome-nettool-3.8.1
	>=gnome-extra/gnome-tweak-tool-3.22.0
	>=gnome-extra/nautilus-sendto-3.8.4
	>=net-misc/vinagre-3.22.0

	games? (
		>=games-puzzle/five-or-more-${PV}
		>=games-board/four-in-a-row-3.22.1
		>=games-board/gnome-chess-${PV}
		>=games-puzzle/gnome-klotski-3.22.1
		>=games-board/gnome-mahjongg-3.22.0
		>=games-board/gnome-mines-${PV}
		>=games-arcade/gnome-nibbles-3.22.1
		>=games-arcade/gnome-robots-3.22.1
		>=games-puzzle/gnome-sudoku-3.22.2
		>=games-puzzle/gnome-taquin-3.22.0
		>=games-puzzle/gnome-tetravex-3.22.0
		>=games-puzzle/hitori-3.22.0
		>=games-board/iagno-3.22.0
		>=games-puzzle/lightsoff-3.22.2
		>=games-puzzle/quadrapassel-3.22.0
		>=games-puzzle/swell-foop-${PV}
		>=games-board/tali-3.22.0
	)
	share? ( >=gnome-extra/gnome-user-share-3.18.3 )
	shotwell? ( >=media-gfx/shotwell-0.24 )
	tracker? (
		>=app-misc/tracker-1.10.1
		>=gnome-extra/gnome-documents-3.22.0
		>=media-gfx/gnome-photos-${PV}
		>=media-sound/gnome-music-3.22.1 )
"
DEPEND=""
S=${WORKDIR}
