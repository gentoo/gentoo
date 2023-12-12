# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_QTHELP="true"
ECM_TEST="true"
KFMIN=5.106.0
QTMIN=5.15.9
inherit ecm gear.kde.org

DESCRIPTION="Library for accessing public transport timetables and other information"
HOMEPAGE="https://invent.kde.org/libraries/kpublictransport
	https://www.volkerkrause.eu/2019/03/02/kpublictransport-introduction.html"

LICENSE="LGPL-2+"
SLOT="5"
KEYWORDS="~amd64"
IUSE="networkmanager"

RDEPEND="
	dev-libs/protobuf:=
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5[ssl]
	>=kde-frameworks/ki18n-${KFMIN}:5
	sys-libs/zlib
	networkmanager? ( >=kde-frameworks/networkmanager-qt-${KFMIN}:5 )
"
DEPEND="${RDEPEND}
	test? ( >=dev-qt/qtwidgets-${QTMIN}:5 )
"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_OsmTools=ON # we have no use for it
		$(cmake_use_find_package networkmanager KF5NetworkManagerQt)
	)
	ecm_src_configure
}
