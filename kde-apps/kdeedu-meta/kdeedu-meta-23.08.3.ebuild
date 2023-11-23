# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="KDE educational apps - merge this to pull in all kdeedu-derived packages"
HOMEPAGE="https://edu.kde.org"

LICENSE="metapackage"
SLOT="5"
KEYWORDS="amd64 arm64 x86"
IUSE="+webengine"

RDEPEND="
	>=kde-apps/analitza-${PV}:${SLOT}
	>=kde-apps/artikulate-${PV}:${SLOT}
	>=kde-apps/blinken-${PV}:${SLOT}
	>=kde-apps/kalzium-${PV}:${SLOT}
	>=kde-apps/kanagram-${PV}:${SLOT}
	>=kde-apps/kbruch-${PV}:${SLOT}
	>=kde-apps/kdeedu-data-${PV}:${SLOT}
	>=kde-apps/kgeography-${PV}:${SLOT}
	>=kde-apps/khangman-${PV}:${SLOT}
	>=kde-apps/kig-${PV}:${SLOT}
	>=kde-apps/kiten-${PV}:${SLOT}
	>=kde-apps/klettres-${PV}:${SLOT}
	>=kde-apps/kmplot-${PV}:${SLOT}
	>=kde-apps/kqtquickcharts-${PV}:${SLOT}
	>=kde-apps/ktouch-${PV}:${SLOT}
	>=kde-apps/kturtle-${PV}:${SLOT}
	>=kde-apps/kwordquiz-${PV}:${SLOT}
	>=kde-apps/libkeduvocdocument-${PV}:${SLOT}
	>=kde-apps/marble-${PV}:${SLOT}
	>=kde-apps/minuet-${PV}:${SLOT}
	>=kde-apps/rocs-${PV}:${SLOT}
	>=kde-apps/step-${PV}:${SLOT}
	webengine? (
		>=kde-apps/cantor-${PV}:${SLOT}
		>=kde-apps/kalgebra-${PV}:${SLOT}
		>=kde-apps/parley-${PV}:${SLOT}
	)
"
