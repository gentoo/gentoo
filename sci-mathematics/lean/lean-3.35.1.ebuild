# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_IN_SOURCE_BUILD="ON"

inherit cmake optfeature

DESCRIPTION="The Lean Theorem Prover"
HOMEPAGE="https://leanprover-community.github.io/"

if [[ "${PV}" == *9999* ]]; then
	MAJOR=3  # sync this periodically for the live version
	inherit git-r3
	EGIT_REPO_URI="https://github.com/leanprover-community/lean.git"
else
	MAJOR=$(ver_cut 1)
	SRC_URI="https://github.com/leanprover-community/lean/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi
S="${WORKDIR}/lean-${PV}/src"

LICENSE="Apache-2.0"
SLOT="0/${MAJOR}"
IUSE="debug +json +threads"

RDEPEND="dev-libs/gmp"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}/${PN}-CMakeLists-fix_flags.patch" )

src_configure() {
	local CMAKE_BUILD_TYPE
	if use debug; then
		CMAKE_BUILD_TYPE="Debug"
	else
		CMAKE_BUILD_TYPE="Release"
	fi

	local mycmakeargs=(
		-DALPHA=ON
		-DAUTO_THREAD_FINALIZATION=ON
		-DJSON=$(usex json)
		-DLEAN_EXTRA_CXX_FLAGS="${CXXFLAGS}"
		-DMULTI_THREAD=$(usex threads)
		-DUSE_GITHASH=OFF
	)
	cmake_src_configure
}

src_test() {
	local myctestargs=(
		# Disable problematic "style_check" cpplint test,
		# this also removes the python test dependency
		--exclude-regex style_check
	)
	cmake_src_test
}

pkg_postinst() {
	elog "You probably want to use lean with mathlib, you can either:"
	elog " - Do not install mathlib globally and use local versions"
	elog " - Use leanproject from sci-mathematics/mathlib-tools"
	elog "   $ leanproject global-install"
	elog " - Use leanpkg and compile mathlib (which will take some time)"
	elog "   $ leanpkg install https://github.com/leanprover-community/mathlib"
}
