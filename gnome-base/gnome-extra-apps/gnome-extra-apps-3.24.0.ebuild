# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Sub-meta package for the applications of GNOME 3"
HOMEPAGE="https://www.gnome.org/"
LICENSE="metapackage"
SLOT="3.0"
IUSE="+games +share +shotwell +tracker"

KEYWORDS="~amd64 ~x86"

# Note to developers:
# This is a wrapper for the extra apps integrated with GNOME 3
# Keep pkg order within a USE flag as upstream releng versions file
# TODO: Should we keep these here: gnome-power-manager, gucharmap, sound-juicer
RDEPEND="
	>=gnome-base/gnome-core-libs-${PV}

	>=sys-apps/baobab-${PV}
	>=media-video/cheese-${PV}
	>=www-client/epiphany-${PV}
	>=app-arch/file-roller-${PV}
	>=gnome-extra/gnome-calculator-${PV}
	>=gnome-extra/gnome-calendar-${PV}
	>=gnome-extra/gnome-characters-${PV}
	>=sys-apps/gnome-disk-utility-${PV}
	>=media-gfx/gnome-font-viewer-${PV}
	>=gnome-extra/gnome-power-manager-${PV}
	>=media-gfx/gnome-screenshot-3.22.0
	>=gnome-extra/gnome-system-monitor-${PV}
	>=gnome-extra/gnome-weather-${PV}
	>=gnome-extra/gucharmap-10:2.90
	>=gnome-extra/sushi-${PV}
	>=media-sound/sound-juicer-${PV}
	>=net-misc/vino-3.22.0

	>=gnome-base/dconf-editor-3.22.3
	>=app-dicts/gnome-dictionary-${PV}
	>=mail-client/evolution-${PV}
	>=net-analyzer/gnome-nettool-3.8.1
	>=gnome-extra/gnome-tweak-tool-${PV}
	>=gnome-extra/nautilus-sendto-3.8.4
	>=net-misc/vinagre-3.22.0

	games? (
		>=games-puzzle/five-or-more-3.22.2
		>=games-board/four-in-a-row-3.22.1
		>=games-board/gnome-chess-${PV}
		>=games-puzzle/gnome-klotski-3.22.1
		>=games-board/gnome-mahjongg-3.22.0
		>=games-board/gnome-mines-${PV}
		>=games-arcade/gnome-nibbles-${PV}
		>=games-arcade/gnome-robots-3.22.1
		>=games-puzzle/gnome-sudoku-${PV}
		>=games-puzzle/gnome-taquin-3.22.0
		>=games-puzzle/gnome-tetravex-3.22.0
		>=games-puzzle/hitori-3.22.0
		>=games-board/iagno-3.22.0
		>=games-puzzle/lightsoff-$PV
		>=games-puzzle/quadrapassel-3.22.0
		>=games-puzzle/swell-foop-${PV}
		>=games-board/tali-3.22.0
	)
	share? ( >=gnome-extra/gnome-user-share-3.18.3 )
	shotwell? ( >=media-gfx/shotwell-0.26 )
	tracker? (
		>=app-misc/tracker-1.12
		>=gnome-extra/gnome-documents-${PV}
		>=media-gfx/gnome-photos-${PV}
		>=media-sound/gnome-music-${PV} )
"
DEPEND=""
S=${WORKDIR}
