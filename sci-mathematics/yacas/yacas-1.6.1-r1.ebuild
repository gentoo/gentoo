# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CMAKE_IN_SOURCE_BUILD=1

inherit java-pkg-opt-2 cmake-utils

DESCRIPTION="General purpose computer algebra system"
HOMEPAGE="http://www.yacas.org/"
SRC_URI="https://codeload.github.com/grzegorzmazur/${PN}/tar.gz/v${PV} -> ${P}.tar.gz"

SLOT="0/1"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="doc gui java +jupyter static-libs"

COMMON_DEPEND="
	gui? (
		dev-qt/qtcore:5[icu]
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
		dev-qt/qtnetwork:5
		dev-qt/qtwebkit:5
		dev-qt/qtmultimedia:5
		dev-qt/qtsql:5
		dev-qt/qtprintsupport:5
		dev-qt/qtopengl:5
		dev-qt/qtprintsupport:5
	)
	jupyter? (
		dev-python/jupyter
		dev-libs/boost:=
		dev-libs/jsoncpp:=
		dev-libs/openssl:0=
		net-libs/zeromq
		>=net-libs/zmqpp-4.1.2
	)"
DEPEND="${COMMON_DEPEND}
	doc? ( dev-python/sphinx )
	java? ( >=virtual/jdk-1.6 )"
RDEPEND="${COMMON_DEPEND}
	java? ( >=virtual/jre-1.6 )"

src_configure() {
	local mycmakeargs=(
		-DENABLE_DOCS=$(usex doc)
		-DENABLE_CYACAS_GUI=$(usex gui)
		-DENABLE_CYACAS_KERNEL=$(usex jupyter)
		-DENABLE_JYACAS=$(usex java)
	)
	cmake-utils_src_configure
}
