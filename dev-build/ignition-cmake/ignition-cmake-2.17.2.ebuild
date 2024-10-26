# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="CMake modules to be used by the Ignition projects"
HOMEPAGE="https://github.com/ignitionrobotics/ign-cmake"
SRC_URI="https://github.com/gazebosim/gz-cmake/archive/refs/tags/${PN}2_${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="2"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"
PATCHES=( "${FILESDIR}/protobuf.patch" )
S="${WORKDIR}/gz-cmake-${PN}2_${PV}"

src_configure() {
	local mycmakeargs=(
		"-DBUILD_TESTING=$(usex test)"
	)
	cmake_src_configure
}
