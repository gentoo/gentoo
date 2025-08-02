# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Robot Raconteur C++ Companion Library"
HOMEPAGE="https://github.com/robotraconteur/robotraconteur_companion"
SRC_URI="https://github.com/robotraconteur/robotraconteur_companion/releases/download/v${PV}/RobotRaconteurCompanion-${PV}-Source.tar.gz"

S="${WORKDIR}/RobotRaconteurCompanion-${PV}-Source"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="amd64 ~arm arm64 ~x86"
IUSE=""

DEPEND="dev-libs/boost
    dev-libs/openssl
    dev-build/cmake
    dev-cpp/yaml-cpp
    dev-cpp/eigen
    dev-cpp/robotraconteur
"
RDEPEND="${DEPEND}"

src_configure() {
local mycmakeargs=(
        -DCMAKE_SKIP_RPATH=ON
        -DBUILD_TESTING=OFF
        -DBUILD_DOCUMENTATION=OFF
        -DROBOTRACONTEUR_COMPANION_SOVERSION_MAJOR_ONLY=ON
    )
    cmake_src_configure
}

src_compile() {
    cmake_src_compile
}

src_install() {
    cmake_src_install
}
