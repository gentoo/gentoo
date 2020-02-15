# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

COMMIT="fafc3cd747457906290df773063ad8022684a33a"
MY_PN="tsMuxer"

DESCRIPTION="Utility to create and demux TS and M2TS files"
HOMEPAGE="https://github.com/justdan96/tsMuxer"
SRC_URI="https://github.com/justdan96/${MY_PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="qt5"

BDEPEND="virtual/pkgconfig
	qt5? ( dev-qt/linguist-tools:5 )"
DEPEND="qt5? (
		dev-qt/qtmultimedia:5
		dev-qt/qtwidgets:5
	)
	media-libs/freetype
	sys-libs/zlib"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_PN}-${COMMIT}"

DOCS=( README.md )

src_configure() {
	local mycmakeargs=(
		-DTSMUXER_STATIC_BUILD=OFF
		-DTSMUXER_GUI=$(usex qt5)
	)
	cmake_src_configure
}
