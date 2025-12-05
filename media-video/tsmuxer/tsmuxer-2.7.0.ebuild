# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="tsMuxer"
inherit cmake xdg

DESCRIPTION="Utility to create and demux TS and M2TS files"
HOMEPAGE="https://github.com/justdan96/tsMuxer"
SRC_URI="https://github.com/justdan96/tsMuxer/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gui"

DEPEND="
	gui? (
		dev-qt/qtbase:6[gui,widgets]
		dev-qt/qtmultimedia:6
	)
	media-libs/freetype
	virtual/zlib:=
"
RDEPEND="${DEPEND}"
BDEPEND="
	virtual/pkgconfig
	gui? ( dev-qt/qttools:6[linguist] )
"

DOCS=( README.md )

src_configure() {
	local mycmakeargs=(
		-DQT_VERSION=6
		-DTSMUXER_STATIC_BUILD=OFF
		-DTSMUXER_GUI=$(usex gui)
	)
	cmake_src_configure
}
