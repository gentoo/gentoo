# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Sub-meta package for the applications of GNOME"
HOMEPAGE="https://www.gnome.org/"

S=${WORKDIR}

LICENSE="metapackage"
SLOT="3.0"
KEYWORDS="~amd64"

IUSE="+games share +shotwell +tracker"

# Note to developers:
# This is a wrapper for the extra apps integrated with GNOME
# Keep pkg order within a USE flag as upstream releng versions file
# TODO: Replace cheese with Snapshot once we have it packaged
RDEPEND="
	>=gnome-base/gnome-core-libs-${PV}

	>=sys-apps/baobab-49.1

	>=media-video/cheese-44.1

	>=www-client/epiphany-49.9.1
	>=app-arch/file-roller-44.7
	>=gnome-extra/gnome-calculator-49.2
	>=gnome-extra/gnome-calendar-49.1
	>=gnome-extra/gnome-characters-49.1
	>=gnome-extra/gnome-clocks-49.0
	>=sys-apps/gnome-disk-utility-46.1
	>=media-gfx/gnome-font-viewer-49.0
	>=gnome-extra/gnome-system-monitor-49.1
	>=gnome-extra/gnome-weather-49.0
	>=gnome-extra/sushi-46.0
	>=net-misc/gnome-remote-desktop-49.3

	>=gnome-base/dconf-editor-49.0
	>=mail-client/evolution-3.58.3
	>=gnome-extra/gnome-tweaks-49.0
	>=app-crypt/seahorse-47.0.1
	>=net-misc/gnome-connections-49.0

	games? (
		>=games-puzzle/five-or-more-48.1
		>=games-board/four-in-a-row-3.38.1
		>=games-board/gnome-chess-49.2
		>=games-puzzle/gnome-klotski-3.38.2
		>=games-board/gnome-mahjongg-49.1.1
		>=games-board/gnome-mines-49.0.1
		>=games-arcade/gnome-nibbles-4.4.2
		>=games-arcade/gnome-robots-40.0
		>=games-puzzle/gnome-sudoku-49.5
		>=games-puzzle/gnome-taquin-3.38.1
		>=games-puzzle/gnome-tetravex-3.38.3
		>=games-puzzle/hitori-44.0
		>=games-board/iagno-3.38.1
		>=games-puzzle/lightsoff-48.1
		>=games-puzzle/quadrapassel-49.3
		>=games-puzzle/swell-foop-48.1
		>=games-board/tali-40.9
	)
	share? ( >=gnome-extra/gnome-user-share-48.3 )
	shotwell? ( >=media-gfx/shotwell-0.32.17 )
	tracker? (
		>=app-misc/localsearch-3.10.2
		>=app-misc/tinysparql-3.10.1
		>=media-sound/gnome-music-49.1
	)
"
