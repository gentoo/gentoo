# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="kdegames - merge this to pull in all kdegames-derived packages"
HOMEPAGE="https://apps.kde.org/categories/games/"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="amd64 arm64 ~loong ~riscv ~x86"
IUSE="opengl python"

RDEPEND="
	>=games-puzzle/skladnik-${PV}
	>=kde-apps/bomber-${PV}:*
	>=kde-apps/bovo-${PV}:*
	>=kde-apps/granatier-${PV}:*
	>=kde-apps/kapman-${PV}:*
	>=kde-apps/katomic-${PV}:*
	>=kde-apps/kblackbox-${PV}:*
	>=kde-apps/kblocks-${PV}:*
	>=kde-apps/kbounce-${PV}:*
	>=kde-apps/kbreakout-${PV}:*
	>=kde-apps/kdiamond-${PV}:*
	>=kde-apps/kfourinline-${PV}:*
	>=kde-apps/kgoldrunner-${PV}:*
	>=kde-apps/kigo-${PV}:*
	>=kde-apps/killbots-${PV}:*
	>=kde-apps/kiriki-${PV}:*
	>=kde-apps/kjumpingcube-${PV}:*
	>=kde-apps/klickety-${PV}:*
	>=kde-apps/klines-${PV}:*
	>=kde-apps/kmahjongg-${PV}:*
	>=kde-apps/kmines-${PV}:*
	>=kde-apps/knavalbattle-${PV}:*
	>=kde-apps/knetwalk-${PV}:*
	>=kde-apps/knights-${PV}:*
	>=kde-apps/kolf-${PV}:*
	>=kde-apps/kollision-${PV}:*
	>=kde-apps/konquest-${PV}:*
	>=kde-apps/kpat-${PV}:*
	>=kde-apps/kreversi-${PV}:*
	>=kde-apps/kshisen-${PV}:*
	>=kde-apps/ksirk-${PV}:*
	>=kde-apps/ksnakeduel-${PV}:*
	>=kde-apps/kspaceduel-${PV}:*
	>=kde-apps/ksquares-${PV}:*
	>=kde-apps/ktuberling-${PV}:*
	>=kde-apps/libkdegames-${PV}:*
	>=kde-apps/libkmahjongg-${PV}:*
	>=kde-apps/lskat-${PV}:*
	>=kde-apps/palapeli-${PV}:*
	>=kde-apps/picmi-${PV}:*
	opengl? (
		>=kde-apps/ksudoku-${PV}:*
		>=kde-apps/kubrick-${PV}:*
	)
	python? ( >=kde-apps/kajongg-${PV}:* )
"
