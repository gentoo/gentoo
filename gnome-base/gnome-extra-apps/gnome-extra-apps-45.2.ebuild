# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Sub-meta package for the applications of GNOME"
HOMEPAGE="https://www.gnome.org/"
LICENSE="metapackage"
SLOT="3.0"
IUSE="+games share +shotwell +tracker"

KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~riscv ~x86"

# Note to developers:
# This is a wrapper for the extra apps integrated with GNOME
# Keep pkg order within a USE flag as upstream releng versions file
# TODO: Should we keep these here: gnome-dictionary, gucharmap, sound-juicer, file-roller, nautilus-sendto, gnome-photos; replace gucharmap with gnome-characters?
# TODO: Add gnome-remote-desktop as replacement for vino that was removed from meta in 3.36?
# TODO: Replace cheese with Snapshot once we have it packaged
# TODO: Update epiphany min dep
RDEPEND="
	>=gnome-base/gnome-core-libs-${PV}

	>=sys-apps/baobab-45.0
	>=media-video/cheese-44.1
	>=www-client/epiphany-44.6
	>=app-arch/file-roller-43.1
	>=gnome-extra/gnome-calculator-45.0.2
	>=gnome-extra/gnome-calendar-45.1
	>=gnome-extra/gnome-characters-45.0
	>=sys-apps/gnome-disk-utility-45.1
	>=media-gfx/gnome-font-viewer-45.0
	>=gnome-extra/gnome-system-monitor-45.0.2
	>=gnome-extra/gnome-weather-45.0
	>=gnome-extra/sushi-45.0

	>=gnome-base/dconf-editor-45.0.1
	>=mail-client/evolution-3.50.2
	>=gnome-extra/gnome-tweaks-45.0
	>=gnome-extra/nautilus-sendto-3.8.6
	>=app-crypt/seahorse-43.0

	games? (
		>=games-puzzle/five-or-more-3.32.3
		>=games-board/four-in-a-row-3.38.1
		>=games-board/gnome-chess-43.2
		>=games-puzzle/gnome-klotski-3.38.2
		>=games-board/gnome-mahjongg-3.40.0
		>=games-board/gnome-mines-40.1
		>=games-arcade/gnome-nibbles-4.0.1
		>=games-arcade/gnome-robots-40.0
		>=games-puzzle/gnome-sudoku-45.2
		>=games-puzzle/gnome-taquin-3.38.1
		>=games-puzzle/gnome-tetravex-3.38.2
		>=games-puzzle/hitori-44.0
		>=games-board/iagno-3.38.1
		>=games-puzzle/lightsoff-40.0.1
		>=games-puzzle/quadrapassel-40.2
		>=games-puzzle/swell-foop-41.1
		>=games-board/tali-40.9
	)
	share? ( >=gnome-extra/gnome-user-share-43.0 )
	shotwell? ( >=media-gfx/shotwell-0.32.4 )
	tracker? (
		>=app-misc/tracker-3.6.0
		>=app-misc/tracker-miners-3.6.2
		>=media-gfx/gnome-photos-44.0
		>=media-sound/gnome-music-45.0
	)
"
DEPEND=""
BDEPEND=""
S=${WORKDIR}
