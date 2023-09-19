# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MAJOR=$(ver_cut 1)
CMAKE_IN_SOURCE_BUILD="ON"

inherit flag-o-matic cmake readme.gentoo-r1

DESCRIPTION="The Lean Theorem Prover"
HOMEPAGE="https://leanprover-community.github.io/"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/leanprover-community/lean.git"
else
	SRC_URI="https://github.com/leanprover-community/lean/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ~x86"
fi
S="${S}/src"

LICENSE="Apache-2.0"
SLOT="0/${MAJOR}"
IUSE="debug +threads"

RDEPEND="dev-libs/gmp:="
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-3.50.3-gcc-13.patch
	"${FILESDIR}"/${PN}-CMakeLists-fix_flags.patch
)

src_configure() {
	local CMAKE_BUILD_TYPE
	if use debug; then
		CMAKE_BUILD_TYPE="Debug"
	else
		CMAKE_BUILD_TYPE="Release"
	fi

	filter-lto

	local -a mycmakeargs=(
		-DALPHA=ON
		-DAUTO_THREAD_FINALIZATION=ON
		-DJSON=ON  # bug 833900
		-DLEAN_EXTRA_CXX_FLAGS="${CXXFLAGS}"
		-DMULTI_THREAD=$(usex threads)
		-DUSE_GITHASH=OFF
	)
	cmake_src_configure
}

src_test() {
	local -a myctestargs=(
		# Disable problematic "style_check" cpplint test,
		# this also removes the python test dependency
		--exclude-regex style_check
	)
	cmake_src_test
}

src_install() {
	cmake_src_install

	local DISABLE_AUTOFORMATTING="yes"
	local DOC_CONTENTS="You probably want to use lean with mathlib, you can either:
	- Do not install mathlib globally and use local versions
	- Use leanproject from sci-mathematics/mathlib-tools
		$ leanproject global-install
	- Use leanpkg and compile mathlib (which will take some time)
		$ leanpkg install https://github.com/leanprover-community/mathlib"
	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
