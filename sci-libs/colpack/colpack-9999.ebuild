# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake toolchain-funcs

MY_PN="ColPack"

DESCRIPTION="C++ algorithms for specialized vertex coloring problems"
HOMEPAGE="https://cscapes.cs.purdue.edu/coloringpage/"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/CSCsw/ColPack.git"
else
	if [[ ${PV} == *_p* ]] ; then
		COMMIT="9a7293a8dfd66a60434496b8df5ebb4274d70339"
		SRC_URI="
			https://github.com/CSCsw/${MY_PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz
		"
		S="${WORKDIR}/${MY_PN}-${COMMIT}"
	else
		SRC_URI="
			https://github.com/CSCsw/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
		"
		S="${WORKDIR}/${MY_PN}-${PV}"
	fi
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86"
fi

LICENSE="BSD"
SLOT="0"

IUSE="openmp"
RESTRICT="test"

# Upstream is pretty much dead so we backport what's useful
PATCHES=(
	"${FILESDIR}/${PN}-1.0.10-PR32.patch" # Fix install
	"${FILESDIR}/${PN}-1.0.10-PR34.patch" # [cmake] Recovery .h -> .cpp
	"${FILESDIR}/${PN}-1.0.10-PR43.patch" # NULL->string() to eliminate UB, support MSVC 2022
	"${FILESDIR}/${PN}-1.0.10-PR47.patch" # Update Main.cpp
)

# "top-level" CMakeLists.txt is in build/cmake ...
CMAKE_USE_DIR="${S}/build/cmake"
BUILD_DIR="${S}_build"

pkg_pretend() {
	if [[ ${MERGE_TYPE} != binary ]] && use openmp; then
		tc-check-openmp
	fi
}

pkg_setup() {
	if [[ ${MERGE_TYPE} != binary ]] && use openmp; then
		tc-check-openmp
	fi
}

src_configure() {
	local mycmakeargs=(
		# -DENABLE_EXAMPLES="$(usex examples)"
		-DENABLE_OPENMP="$(usex openmp)"
	)

	cmake_src_configure
}
