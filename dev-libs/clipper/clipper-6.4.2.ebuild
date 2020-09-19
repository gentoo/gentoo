# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )

inherit cmake

MY_PV="ver${PV}"
MY_P="${PN}_${MY_PV}"

DESCRIPTION="Polygon and line clipping and offsetting library (C++, C#, Delphi)"
HOMEPAGE="http://www.angusj.com/delphi/clipper.php"
SRC_URI="mirror://sourceforge/project/polyclipping/${MY_P}.zip -> ${P}.zip"

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

IUSE=""

RDEPEND=""
BDEPEND="app-arch/unzip"

S="${WORKDIR}/cpp"

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
	)
	cmake_src_configure
}
