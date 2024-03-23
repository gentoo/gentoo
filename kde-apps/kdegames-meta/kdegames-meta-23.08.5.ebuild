# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="kdegames - merge this to pull in all kdegames-derived packages"
HOMEPAGE="https://apps.kde.org/categories/games/"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="amd64 arm64 ~loong ~riscv x86"
IUSE="opengl python"

RDEPEND="
	>=kde-apps/bomber-${PV}:5
	>=kde-apps/bovo-${PV}:5
	>=kde-apps/granatier-${PV}:5
	>=kde-apps/kapman-${PV}:5
	>=kde-apps/katomic-${PV}:5
	>=kde-apps/kblackbox-${PV}:5
	>=kde-apps/kblocks-${PV}:5
	>=kde-apps/kbounce-${PV}:5
	>=kde-apps/kbreakout-${PV}:5
	>=kde-apps/kdiamond-${PV}:5
	>=kde-apps/kfourinline-${PV}:5
	>=kde-apps/kgoldrunner-${PV}:5
	>=kde-apps/kigo-${PV}:5
	>=kde-apps/killbots-${PV}:5
	>=kde-apps/kiriki-${PV}:5
	>=kde-apps/kjumpingcube-${PV}:5
	>=kde-apps/klickety-${PV}:5
	>=kde-apps/klines-${PV}:5
	>=kde-apps/kmahjongg-${PV}:5
	>=kde-apps/kmines-${PV}:5
	>=kde-apps/knavalbattle-${PV}:5
	>=kde-apps/knetwalk-${PV}:5
	>=kde-apps/knights-${PV}:5
	>=kde-apps/kolf-${PV}:5
	>=kde-apps/kollision-${PV}:5
	>=kde-apps/konquest-${PV}:5
	>=kde-apps/kpat-${PV}:5
	>=kde-apps/kreversi-${PV}:5
	>=kde-apps/kshisen-${PV}:5
	>=kde-apps/ksirk-${PV}:5
	>=kde-apps/ksnakeduel-${PV}:5
	>=kde-apps/kspaceduel-${PV}:5
	>=kde-apps/ksquares-${PV}:5
	>=kde-apps/ktuberling-${PV}:5
	>=kde-apps/libkdegames-${PV}:5
	>=kde-apps/libkmahjongg-${PV}:5
	>=kde-apps/lskat-${PV}:5
	>=kde-apps/palapeli-${PV}:5
	>=kde-apps/picmi-${PV}:5
	opengl? (
		>=kde-apps/ksudoku-${PV}:5
		>=kde-apps/kubrick-${PV}:5
	)
	python? ( >=kde-apps/kajongg-${PV}:5 )
"
