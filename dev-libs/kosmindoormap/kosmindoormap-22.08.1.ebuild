# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="true"
PVCUT=$(ver_cut 1-3)
KFMIN=5.96.0
QTMIN=5.15.5
inherit ecm gear.kde.org

DESCRIPTION="Data Model and Extraction System for Travel Reservation information"
HOMEPAGE="https://invent.kde.org/libraries/kosmindoormap"

LICENSE="LGPL-2+"
SLOT="5"
KEYWORDS="~amd64"
IUSE="+openinghours"

COMMON_DEPEND="
	>=dev-libs/kpublictransport-${PVCUT}:5
	dev-libs/protobuf:=
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	sys-libs/zlib
	openinghours? ( >=dev-libs/kopeninghours-${PVCUT}:5 )
"
DEPEND="${COMMON_DEPEND}
	test? ( >=dev-qt/qtwidgets-${QTMIN}:5 )
"
RDEPEND="${COMMON_DEPEND}
	>=dev-qt/qtquickcontrols2-${QTMIN}:5
"
BDEPEND="
	sys-devel/bison
	sys-devel/flex
"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_OsmTools=ON # we have no use for it
		$(cmake_use_find_package openinghours KOpeningHours)
	)
	ecm_src_configure
}
