# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_QTHELP="true"
ECM_TEST="true"
KFMIN=6.22.0
QTMIN=6.10.1
inherit ecm gear.kde.org

DESCRIPTION="Library for accessing public transport timetables and other information"
HOMEPAGE="https://invent.kde.org/libraries/kpublictransport
	https://www.volkerkrause.eu/2019/03/02/kpublictransport-introduction.html"

LICENSE="LGPL-2+"
SLOT="6/$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm64"
IUSE="networkmanager"

RDEPEND="
	>=dev-libs/kirigami-addons-1.6.0:6
	dev-libs/protobuf:=
	>=dev-qt/qtbase-${QTMIN}:6[gui,network,ssl]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=dev-qt/qtlocation-${QTMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kitemmodels-${KFMIN}:6
	virtual/zlib:=
	networkmanager? ( >=kde-frameworks/networkmanager-qt-${KFMIN}:6 )
"
DEPEND="${RDEPEND}
	test? ( >=dev-qt/qtbase-${QTMIN}:6[widgets] )
"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_OsmTools=ON # we have no use for it
		$(cmake_use_find_package networkmanager KF6NetworkManagerQt)
	)
	ecm_src_configure
}
