# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="KDE educational apps - merge this to pull in all kdeedu-derived packages"
HOMEPAGE="https://apps.kde.org/categories/education/"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="qt5 +webengine"

RDEPEND="
	>=kde-apps/analitza-${PV}:*
	qt5? ( >=kde-apps/artikulate-25.04.0:* )
	>=kde-apps/blinken-${PV}:*
	>=kde-apps/cantor-${PV}:*
	>=kde-apps/kalzium-${PV}:*
	>=kde-apps/kanagram-${PV}:*
	>=kde-apps/kbruch-${PV}:*
	>=kde-apps/kdeedu-data-${PV}:*
	>=kde-apps/kgeography-${PV}:*
	>=kde-apps/khangman-${PV}:*
	qt5? ( >=kde-apps/kig-25.04.0:* )
	>=kde-apps/kiten-${PV}:*
	>=kde-apps/klettres-${PV}:*
	>=kde-apps/kmplot-${PV}:*
	qt5? ( >=kde-apps/kqtquickcharts-25.04.0:* )
	qt5? ( >=kde-apps/ktouch-25.04.0:* )
	>=kde-apps/kturtle-${PV}:*
	>=kde-apps/kwordquiz-${PV}:*
	>=kde-apps/libkeduvocdocument-${PV}:*
	>=kde-apps/marble-${PV}:*
	>=kde-apps/minuet-${PV}:*
	qt5? ( >=kde-apps/rocs-25.04.0:* )
	>=kde-apps/step-${PV}:*
	webengine? (
		>=kde-apps/kalgebra-${PV}:*
		>=kde-apps/parley-${PV}:*
	)
"
