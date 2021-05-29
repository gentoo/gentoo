# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Sub-meta package for the applications of GNOME 3"
HOMEPAGE="https://www.gnome.org/"
LICENSE="metapackage"
SLOT="3.0"
IUSE="+games share +shotwell +tracker"

KEYWORDS="~amd64 ~arm64 x86"

# Note to developers:
# This is a wrapper for the extra apps integrated with GNOME 3
# Keep pkg order within a USE flag as upstream releng versions file
# TODO: Should we keep these here: gnome-dictionary, gucharmap, sound-juicer, vinagre; replace gucharmap with gnome-characters?
# TODO: Add gnome-remote-desktop as replacement for vino that was removed from meta in 3.36?
# gnome-documents removed for now, as it didn't find a good place upstream and is getting dropped from default sets for distros for 3.30 (and for 3.26 it required newer tracker than we had at the time)
RDEPEND="
	>=gnome-base/gnome-core-libs-${PV}

	>=sys-apps/baobab-40.0
	>=media-video/cheese-3.38.0
	>=www-client/epiphany-40.0
	>=app-arch/file-roller-3.38.0
	>=gnome-extra/gnome-calculator-40.0
	>=gnome-extra/gnome-calendar-40.0
	>=gnome-extra/gnome-characters-40.0
	>=sys-apps/gnome-disk-utility-40.0
	>=media-gfx/gnome-font-viewer-40.0
	>=media-gfx/gnome-screenshot-40.0
	>=gnome-extra/gnome-system-monitor-40.0
	>=gnome-extra/gnome-weather-40.0
	>=gnome-extra/gucharmap-13.0.7:2.90
	>=gnome-extra/sushi-3.38.0
	>=media-sound/sound-juicer-3.38.0

	>=gnome-base/dconf-editor-3.38.3
	>=app-dicts/gnome-dictionary-40.0
	>=mail-client/evolution-3.${PV}
	>=gnome-extra/gnome-tweaks-40.0
	>=gnome-extra/nautilus-sendto-3.8.6
	>=net-misc/vinagre-3.22.0

	games? (
		>=games-puzzle/five-or-more-3.32.2
		>=games-board/four-in-a-row-3.38.1
		>=games-board/gnome-chess-40.0
		>=games-puzzle/gnome-klotski-3.38.2
		>=games-board/gnome-mahjongg-3.38.3
		>=games-board/gnome-mines-40.0
		>=games-arcade/gnome-nibbles-3.38.2
		>=games-arcade/gnome-robots-40.0
		>=games-puzzle/gnome-sudoku-40.0
		>=games-puzzle/gnome-taquin-3.38.1
		>=games-puzzle/gnome-tetravex-3.38.2
		>=games-puzzle/hitori-3.36.0
		>=games-board/iagno-3.38.1
		>=games-puzzle/lightsoff-40.0
		>=games-puzzle/quadrapassel-3.38.1
		>=games-puzzle/swell-foop-40.0
		>=games-board/tali-40.0
	)
	share? ( >=gnome-extra/gnome-user-share-3.34.0 )
	shotwell? ( >=media-gfx/shotwell-0.30.11 )
	tracker? (
		>=app-misc/tracker-3
		>=app-misc/tracker-miners-3
		>=media-gfx/gnome-photos-40.0
		>=media-sound/gnome-music-40.0
	)
"
DEPEND=""
BDEPEND=""
S=${WORKDIR}
