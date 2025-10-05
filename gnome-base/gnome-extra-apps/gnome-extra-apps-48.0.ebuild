# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Sub-meta package for the applications of GNOME"
HOMEPAGE="https://www.gnome.org/"

S="${WORKDIR}"

LICENSE="metapackage"
SLOT="3.0"
KEYWORDS="~amd64"

IUSE="+games share +shotwell +tracker"

# Note to developers:
# This is a wrapper for the extra apps integrated with GNOME
# Keep pkg order within a USE flag as upstream releng versions file
# TODO: Replace cheese with Snapshot once we have it packaged
DEPEND=""
RDEPEND="
	>=gnome-base/gnome-core-libs-${PV}

	>=sys-apps/baobab-${PV}

	>=media-video/cheese-44.1

	>=www-client/epiphany-${PV}
	>=app-arch/file-roller-44.5
	>=gnome-extra/gnome-calculator-${PV}
	>=gnome-extra/gnome-calendar-${PV}
	>=gnome-extra/gnome-characters-${PV}
	>=gnome-extra/gnome-clocks-${PV}
	>=sys-apps/gnome-disk-utility-46.1
	>=media-gfx/gnome-font-viewer-${PV}
	>=gnome-extra/gnome-system-monitor-${PV}
	>=gnome-extra/gnome-weather-${PV}
	>=gnome-extra/sushi-46.0
	>=net-misc/gnome-remote-desktop-${PV}

	>=gnome-base/dconf-editor-45.0.1
	>=mail-client/evolution-3.56
	>=gnome-extra/gnome-tweaks-46.1-r1
	>=app-crypt/seahorse-47.0.1-r1
	>=net-misc/gnome-connections-${PV}

	games? (
		>=games-puzzle/five-or-more-${PV}
		>=games-board/four-in-a-row-3.38.1
		>=games-board/gnome-chess-${PV}
		>=games-puzzle/gnome-klotski-3.38.2
		>=games-board/gnome-mahjongg-${PV}
		>=games-board/gnome-mines-${PV}
		>=games-arcade/gnome-nibbles-4.2
		>=games-arcade/gnome-robots-40.0
		>=games-puzzle/gnome-sudoku-${PV}
		>=games-puzzle/gnome-taquin-3.38.1-r1
		>=games-puzzle/gnome-tetravex-3.38.2
		>=games-puzzle/hitori-44.0
		>=games-board/iagno-3.38.1-r1
		>=games-puzzle/lightsoff-${PV}
		>=games-puzzle/quadrapassel-40.2
		>=games-puzzle/swell-foop-${PV}
		>=games-board/tali-40.9
	)
	share? ( >=gnome-extra/gnome-user-share-47.2 )
	shotwell? ( >=media-gfx/shotwell-0.32.13 )
	tracker? (
		>=app-misc/localsearch-3.8.2
		>=app-misc/tinysparql-3.8.2
		>=media-gfx/gnome-photos-44.0
		>=media-sound/gnome-music-${PV}
	)
"
BDEPEND=""
