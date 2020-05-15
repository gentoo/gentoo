# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

DESCRIPTION="CMake modules to be used by the Ignition projects."
HOMEPAGE="https://bitbucket.org/ignitionrobotics/ign-cmake"
SRC_URI="https://osrf-distributions.s3.amazonaws.com/ign-cmake/releases/${PN}2-${PV}.tar.bz2"

LICENSE="Apache-2.0"
SLOT="2"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		"-DBUILD_TESTING=OFF"
	)
	cmake-utils_src_configure
}
