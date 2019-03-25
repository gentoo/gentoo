# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Sub-meta package for the applications of GNOME 3"
HOMEPAGE="https://www.gnome.org/"
LICENSE="metapackage"
SLOT="3.0"
IUSE="+games share +shotwell +tracker"

KEYWORDS="~amd64 ~x86"

# Note to developers:
# This is a wrapper for the extra apps integrated with GNOME 3
# Keep pkg order within a USE flag as upstream releng versions file
# TODO: Should we keep these here: gucharmap, sound-juicer, vinagre; replace gucharmap with gnome-characters?
# gnome-documents removed for now, as it didn't find a good place upstream and is getting dropped from default sets for distros for 3.30 (and for 3.26 it required newer tracker than we had at the time)
RDEPEND="
	>=gnome-base/gnome-core-libs-${PV}

	>=sys-apps/baobab-3.28.0
	>=media-video/cheese-3.28.0
	>=www-client/epiphany-3.28.1.1
	>=app-arch/file-roller-3.28.0
	>=gnome-extra/gnome-calculator-3.28.1
	>=gnome-extra/gnome-calendar-${PV}
	>=gnome-extra/gnome-characters-${PV}
	>=sys-apps/gnome-disk-utility-${PV}
	>=media-gfx/gnome-font-viewer-3.28.0
	>=media-gfx/gnome-screenshot-3.26.0
	>=gnome-extra/gnome-system-monitor-3.28.2
	>=gnome-extra/gnome-weather-3.26.0
	>=gnome-extra/gucharmap-10.0.3:2.90
	>=gnome-extra/sushi-3.28.3
	>=media-sound/sound-juicer-3.24.0
	>=net-misc/vino-3.22.0

	>=gnome-base/dconf-editor-3.28.0
	>=app-dicts/gnome-dictionary-3.26.1
	>=mail-client/evolution-${PV}
	>=gnome-extra/gnome-tweaks-3.28.1
	>=gnome-extra/nautilus-sendto-3.8.6
	>=net-misc/vinagre-3.22.0

	games? (
		>=games-puzzle/five-or-more-3.28.0
		>=games-board/four-in-a-row-3.28.0
		>=games-board/gnome-chess-3.28.1
		>=games-puzzle/gnome-klotski-3.22.3
		>=games-board/gnome-mahjongg-3.22.0
		>=games-board/gnome-mines-3.28.0
		>=games-arcade/gnome-nibbles-3.24.1
		>=games-arcade/gnome-robots-3.22.3
		>=games-puzzle/gnome-sudoku-3.28.0
		>=games-puzzle/gnome-taquin-3.28.0
		>=games-puzzle/gnome-tetravex-3.22.0
		>=games-puzzle/hitori-3.22.4
		>=games-board/iagno-3.28.0
		>=games-puzzle/lightsoff-3.28.0
		>=games-puzzle/quadrapassel-3.22.0
		>=games-puzzle/swell-foop-3.28.0
		>=games-board/tali-3.22.0
	)
	share? ( >=gnome-extra/gnome-user-share-3.28.0 )
	shotwell? ( >=media-gfx/shotwell-0.28.4 )
	tracker? (
		>=app-misc/tracker-2.0.3
		>=app-misc/tracker-miners-2.0.4
		>=media-gfx/gnome-photos-3.28.0
		>=media-sound/gnome-music-3.28.2.1 )
"
DEPEND=""
S=${WORKDIR}
