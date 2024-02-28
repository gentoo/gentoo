# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="KDE educational apps - merge this to pull in all kdeedu-derived packages"
HOMEPAGE="https://edu.kde.org"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="+webengine"

RDEPEND="
	>=kde-apps/analitza-${PV}:5
	>=kde-apps/artikulate-${PV}:5
	>=kde-apps/blinken-${PV}:5
	>=kde-apps/kalzium-${PV}:5
	>=kde-apps/kanagram-${PV}:5
	>=kde-apps/kbruch-${PV}:5
	>=kde-apps/kdeedu-data-${PV}:*
	>=kde-apps/kgeography-${PV}:5
	>=kde-apps/khangman-${PV}:5
	>=kde-apps/kig-${PV}:5
	>=kde-apps/kiten-${PV}:5
	>=kde-apps/klettres-${PV}:5
	>=kde-apps/kmplot-${PV}:5
	>=kde-apps/kqtquickcharts-${PV}:5
	>=kde-apps/ktouch-${PV}:5
	>=kde-apps/kturtle-${PV}:5
	>=kde-apps/kwordquiz-${PV}:5
	>=kde-apps/libkeduvocdocument-${PV}:5
	>=kde-apps/marble-${PV}:5
	>=kde-apps/minuet-${PV}:5
	>=kde-apps/rocs-${PV}:5
	>=kde-apps/step-${PV}:5
	webengine? (
		>=kde-apps/cantor-${PV}:5
		>=kde-apps/kalgebra-${PV}:5
		>=kde-apps/parley-${PV}:5
	)
"
