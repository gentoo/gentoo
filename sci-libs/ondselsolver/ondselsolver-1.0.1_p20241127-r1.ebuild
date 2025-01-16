# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

COMMIT=07785b7576a0655660badd845f06ed286208da1a

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
