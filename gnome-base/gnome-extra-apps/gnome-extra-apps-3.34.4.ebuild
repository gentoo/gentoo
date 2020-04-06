# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Sub-meta package for the applications of GNOME 3"
HOMEPAGE="https://www.gnome.org/"
LICENSE="metapackage"
SLOT="3.0"
IUSE="+games share +shotwell +tracker"

KEYWORDS="~amd64 ~arm64 ~x86"

# Note to developers:
# This is a wrapper for the extra apps integrated with GNOME 3
# Keep pkg order within a USE flag as upstream releng versions file
# TODO: Should we keep these here: gnome-dictionary, gucharmap, sound-juicer, vinagre, vino; replace gucharmap with gnome-characters?
# gnome-documents removed for now, as it didn't find a good place upstream and is getting dropped from default sets for distros for 3.30 (and for 3.26 it required newer tracker than we had at the time)
RDEPEND="
	>=gnome-base/gnome-core-libs-${PV}

	>=sys-apps/baobab-3.34.0
	>=media-video/cheese-3.34.0
	>=www-client/epiphany-${PV}
	>=app-arch/file-roller-3.32.4
	>=gnome-extra/gnome-calculator-3.34.1
	>=gnome-extra/gnome-calendar-3.34.2
	>=gnome-extra/gnome-characters-3.32.1
	>=sys-apps/gnome-disk-utility-3.34.4
	>=media-gfx/gnome-font-viewer-3.34.0
	>=media-gfx/gnome-screenshot-3.34.0
	>=gnome-extra/gnome-system-monitor-3.32.1
	>=gnome-extra/gnome-weather-3.34.0
	>=gnome-extra/gucharmap-12.0.1:2.90
	>=gnome-extra/sushi-3.34.0
	>=media-sound/sound-juicer-3.24.0
	>=net-misc/vino-3.22.0

	>=gnome-base/dconf-editor-3.34.4
	>=app-dicts/gnome-dictionary-3.26.1
	>=mail-client/evolution-${PV}
	>=gnome-extra/gnome-tweaks-3.34.0
	>=gnome-extra/nautilus-sendto-3.8.6
	>=net-misc/vinagre-3.22.0

	games? (
		>=games-puzzle/five-or-more-3.32.1
		>=games-board/four-in-a-row-3.34.4
		>=games-board/gnome-chess-3.34.0
		>=games-puzzle/gnome-klotski-3.34.4
		>=games-board/gnome-mahjongg-3.34.0
		>=games-board/gnome-mines-3.34.0
		>=games-arcade/gnome-nibbles-3.34.2
		>=games-arcade/gnome-robots-3.34.1
		>=games-puzzle/gnome-sudoku-3.34.1
		>=games-puzzle/gnome-taquin-3.34.4
		>=games-puzzle/gnome-tetravex-3.34.4
		>=games-puzzle/hitori-3.34.0
		>=games-board/iagno-3.34.5
		>=games-puzzle/lightsoff-3.34.0
		>=games-puzzle/quadrapassel-3.34.1
		>=games-puzzle/swell-foop-3.34.1
		>=games-board/tali-3.32.1
	)
	share? ( >=gnome-extra/gnome-user-share-3.34.0 )
	shotwell? ( >=media-gfx/shotwell-0.30.8 )
	tracker? (
		>=app-misc/tracker-2.3.1
		>=app-misc/tracker-miners-2.3.1
		>=media-gfx/gnome-photos-3.34.1
		>=media-sound/gnome-music-3.34.4 )
"
DEPEND=""
BDEPEND=""
S=${WORKDIR}
