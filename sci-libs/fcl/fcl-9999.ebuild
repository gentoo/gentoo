# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

if [ "${PV}" = "9999" ]; then
	EGIT_REPO_URI="https://github.com/flexible-collision-library/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/flexible-collision-library/fcl/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm"
fi

DESCRIPTION="The Flexible Collision Library"
HOMEPAGE="http://gamma.cs.unc.edu/FCL/"

LICENSE="BSD"
SLOT="0/6"
IUSE="cpu_flags_x86_sse doc +octomap profiling test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-cpp/eigen:3
	dev-libs/boost:=
	sci-libs/flann
	sci-libs/libccd[double-precision]
	octomap? ( sci-libs/octomap:= )"

DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	test? ( dev-cpp/gtest )"

BDEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	sed -i -e "s/include(CompilerSettings)//" "${S}"/CMakeLists.txt || die "failed to remove compiler flags override"

	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test ON OFF)
		-DFCL_COVERALLS=OFF
		-DFCL_COVERALLS_UPLOAD=OFF
		-DFCL_ENABLE_PROFILING=$(usex profiling ON OFF)
		-DFCL_TREAT_WARNINGS_AS_ERRORS=OFF
		-DFCL_USE_HOST_NATIVE_ARCH=OFF
		-DFCL_USE_X64_SSE=$(usex cpu_flags_x86_sse ON OFF)
		-DFCL_WITH_OCTOMAP=$(usex octomap ON OFF)
	)
	local CMAKE_BUILD_TYPE="Release"
	cmake_src_configure
}

src_compile() {
	cmake_src_compile

	use doc && cmake_src_compile docs
}

src_install() {
	cmake_src_install

	use doc && HTML_DOCS=( "${S}"/doc/doxygen/html )
	einstalldocs
}
