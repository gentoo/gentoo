# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

COMMIT=9e44ac50b84dbce0e04907999ff0f33e69f583bc

DESCRIPTION="Assembly Constraints and Multibody Dynamics code"
HOMEPAGE="https://github.com/Ondsel-Development/OndselSolver/"
SRC_URI="https://github.com/Ondsel-Development/OndselSolver/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/OndselSolver-${COMMIT}"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"

IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="test? ( dev-cpp/gtest )"

# These tests result in "Subprocess aborted"
CMAKE_SKIP_TESTS=(
	OndselSolver.Gears
	OndselSolver.anglejoint
	OndselSolver.constvel
	OndselSolver.rackscrew
	OndselSolver.planarbug
	OndselSolver.piston
)

PATCHES=(
	"${FILESDIR}/${P}-system-gtest.patch"
	"${FILESDIR}/${PN}-1.0.1-include-cstdint-gcc15.patch"
)

src_configure() {
	local mycmakeargs=(
		-DONDSELSOLVER_BUILD_TESTS=$(usex test)
	)

	cmake_src_configure
}
