# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="KDE educational apps - merge this to pull in all kdeedu-derived packages"
HOMEPAGE="https://edu.kde.org"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+webengine"

RDEPEND="
	>=kde-apps/analitza-${PV}:*
	>=kde-apps/artikulate-${PV}:*
	>=kde-apps/blinken-${PV}:*
	>=kde-apps/kalzium-${PV}:*
	>=kde-apps/kanagram-${PV}:*
	>=kde-apps/kbruch-${PV}:*
	>=kde-apps/kdeedu-data-${PV}:*
	>=kde-apps/kgeography-${PV}:*
	>=kde-apps/khangman-${PV}:*
	>=kde-apps/kig-${PV}:*
	>=kde-apps/kiten-${PV}:*
	>=kde-apps/klettres-${PV}:*
	>=kde-apps/kmplot-${PV}:*
	>=kde-apps/kqtquickcharts-${PV}:*
	>=kde-apps/ktouch-${PV}:*
	>=kde-apps/kturtle-${PV}:*
	>=kde-apps/kwordquiz-${PV}:*
	>=kde-apps/libkeduvocdocument-${PV}:*
	>=kde-apps/marble-${PV}:*
	>=kde-apps/minuet-${PV}:*
	>=kde-apps/rocs-${PV}:*
	>=kde-apps/step-${PV}:*
	webengine? (
		>=kde-apps/cantor-${PV}:*
		>=kde-apps/kalgebra-${PV}:*
		>=kde-apps/parley-${PV}:*
	)
"
