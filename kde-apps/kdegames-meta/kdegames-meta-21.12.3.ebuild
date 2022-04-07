# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="kdegames - merge this to pull in all kdegames-derived packages"
HOMEPAGE="https://games.kde.org/"

LICENSE="metapackage"
SLOT="5"
KEYWORDS="amd64 ~arm64 ~riscv ~x86"
IUSE="opengl python"

RDEPEND="
	>=kde-apps/bomber-${PV}:${SLOT}
	>=kde-apps/bovo-${PV}:${SLOT}
	>=kde-apps/granatier-${PV}:${SLOT}
	>=kde-apps/kapman-${PV}:${SLOT}
	>=kde-apps/katomic-${PV}:${SLOT}
	>=kde-apps/kblackbox-${PV}:${SLOT}
	>=kde-apps/kblocks-${PV}:${SLOT}
	>=kde-apps/kbounce-${PV}:${SLOT}
	>=kde-apps/kbreakout-${PV}:${SLOT}
	>=kde-apps/kdiamond-${PV}:${SLOT}
	>=kde-apps/kfourinline-${PV}:${SLOT}
	>=kde-apps/kgoldrunner-${PV}:${SLOT}
	>=kde-apps/kigo-${PV}:${SLOT}
	>=kde-apps/killbots-${PV}:${SLOT}
	>=kde-apps/kiriki-${PV}:${SLOT}
	>=kde-apps/kjumpingcube-${PV}:${SLOT}
	>=kde-apps/klickety-${PV}:${SLOT}
	>=kde-apps/klines-${PV}:${SLOT}
	>=kde-apps/kmahjongg-${PV}:${SLOT}
	>=kde-apps/kmines-${PV}:${SLOT}
	>=kde-apps/knavalbattle-${PV}:${SLOT}
	>=kde-apps/knetwalk-${PV}:${SLOT}
	>=kde-apps/knights-${PV}:${SLOT}
	>=kde-apps/kolf-${PV}:${SLOT}
	>=kde-apps/kollision-${PV}:${SLOT}
	>=kde-apps/konquest-${PV}:${SLOT}
	>=kde-apps/kpat-${PV}:${SLOT}
	>=kde-apps/kreversi-${PV}:${SLOT}
	>=kde-apps/kshisen-${PV}:${SLOT}
	>=kde-apps/ksirk-${PV}:${SLOT}
	>=kde-apps/ksnakeduel-${PV}:${SLOT}
	>=kde-apps/kspaceduel-${PV}:${SLOT}
	>=kde-apps/ksquares-${PV}:${SLOT}
	>=kde-apps/ktuberling-${PV}:${SLOT}
	>=kde-apps/libkdegames-${PV}:${SLOT}
	>=kde-apps/libkmahjongg-${PV}:${SLOT}
	>=kde-apps/lskat-${PV}:${SLOT}
	>=kde-apps/palapeli-${PV}:${SLOT}
	>=kde-apps/picmi-${PV}:${SLOT}
	opengl? (
		>=kde-apps/ksudoku-${PV}:${SLOT}
		>=kde-apps/kubrick-${PV}:${SLOT}
	)
	python? ( >=kde-apps/kajongg-${PV}:${SLOT} )
"
