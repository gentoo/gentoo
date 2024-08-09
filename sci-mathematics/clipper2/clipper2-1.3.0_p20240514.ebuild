# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="Clipper2"
MY_P=${MY_PN}_${PV}
COMMIT=ff378668baae3570e9d8070aa9eb339bdd5a6aba

inherit cmake

DESCRIPTION="Polygon Clipping and Offsetting"
HOMEPAGE="https://www.angusj.com/clipper2/Docs/Overview.htm"
SRC_URI="https://github.com/AngusJohnson/Clipper2/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/Clipper2-${COMMIT}/CPP"

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="mirror"

src_configure() {
	local mycmakeargs=(
		-DCLIPPER2_UTILS=OFF
		-DCLIPPER2_EXAMPLES=OFF
		-DCLIPPER2_TESTS=OFF
		-DCLIPPER2_USINGZ=OFF  # manifold src/third_party/CMakeLists.txt
	)
	cmake_src_configure
}
