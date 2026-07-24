# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

COMMIT=9e8a88547e1ee7db534df1921dd694aa3b690d04

DESCRIPTION="Assembly Constraints and Multibody Dynamics code"
HOMEPAGE="https://github.com/FreeCAD/OndselSolver/"
SRC_URI="https://github.com/FreeCAD/OndselSolver/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/OndselSolver-${COMMIT}"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"

IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="test? ( dev-cpp/gtest )"

PATCHES=(
	"${FILESDIR}/${PN}-1.0.1_p20241024-system-gtest.patch"
	"${FILESDIR}/${PN}-1.0.1-properly-demangle-typenames.patch"
)

src_configure() {
	local mycmakeargs=(
		-DONDSELSOLVER_BUILD_TESTS=$(usex test)
	)

	cmake_src_configure
}
