# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit kde5-meta-pkg

DESCRIPTION="kdegames - merge this to pull in all kdegames-derived packages"
HOMEPAGE="https://games.kde.org/"
KEYWORDS="~amd64 ~x86"
IUSE="opengl python"

RDEPEND="
	$(add_kdeapps_dep bomber)
	$(add_kdeapps_dep bovo)
	$(add_kdeapps_dep granatier)
	$(add_kdeapps_dep kapman)
	$(add_kdeapps_dep katomic)
	$(add_kdeapps_dep kblackbox)
	$(add_kdeapps_dep kblocks)
	$(add_kdeapps_dep kbounce)
	$(add_kdeapps_dep kbreakout)
	$(add_kdeapps_dep kdiamond)
	$(add_kdeapps_dep kfourinline)
	$(add_kdeapps_dep kgoldrunner)
	$(add_kdeapps_dep kigo)
	$(add_kdeapps_dep killbots)
	$(add_kdeapps_dep kiriki)
	$(add_kdeapps_dep kjumpingcube)
	$(add_kdeapps_dep klickety)
	$(add_kdeapps_dep klines)
	$(add_kdeapps_dep kmahjongg)
	$(add_kdeapps_dep kmines)
	$(add_kdeapps_dep knavalbattle)
	$(add_kdeapps_dep knetwalk)
	$(add_kdeapps_dep kolf)
	$(add_kdeapps_dep kollision)
	$(add_kdeapps_dep konquest)
	$(add_kdeapps_dep kpat)
	$(add_kdeapps_dep kreversi)
	$(add_kdeapps_dep kshisen)
	$(add_kdeapps_dep ksirk)
	$(add_kdeapps_dep ksnakeduel)
	$(add_kdeapps_dep kspaceduel)
	$(add_kdeapps_dep ksquares)
	$(add_kdeapps_dep ktuberling)
	$(add_kdeapps_dep libkdegames)
	$(add_kdeapps_dep libkmahjongg)
	$(add_kdeapps_dep lskat)
	$(add_kdeapps_dep palapeli)
	$(add_kdeapps_dep picmi)
	opengl? (
		$(add_kdeapps_dep ksudoku)
		$(add_kdeapps_dep kubrick)
	)
	python? ( $(add_kdeapps_dep kajongg) )
"
