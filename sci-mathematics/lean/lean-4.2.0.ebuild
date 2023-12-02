# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MAJOR="$(ver_cut 1)"

CMAKE_MAKEFILE_GENERATOR="emake"
PYTHON_COMPAT=( python3_{10..12} )

inherit cmake flag-o-matic python-any-r1

DESCRIPTION="The Lean Theorem Prover"
HOMEPAGE="https://leanprover-community.github.io/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/leanprover/${PN}${MAJOR}.git"
else
	SRC_URI="https://github.com/leanprover/${PN}${MAJOR}/archive/refs/tags/v${PV/_/-}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}/${PN}${MAJOR}-${PV/_/-}"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="Apache-2.0"
SLOT="0/${MAJOR}"
IUSE="debug source"

RDEPEND="
	dev-libs/gmp:=
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	${PYTHON_DEPS}
"

pkg_setup() {
	python-any-r1_pkg_setup
}

src_prepare() {
	filter-lto

	sed -e "s|-O[23]|${CFLAGS}|g" -i src/CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	local CMAKE_BUILD_TYPE

	if use debug ; then
		CMAKE_BUILD_TYPE="Debug"
	else
		CMAKE_BUILD_TYPE="Release"
	fi

	local -a mycmakeargs=(
		-DLEAN_EXTRA_CXX_FLAGS="${CXXFLAGS}"
		-DLEAN_EXTRA_LINKER_FLAGS="${LDFLAGS}"
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	rm "${ED}/usr/LICENSE"* || die

	if ! use source ; then
		rm -r "${ED}/usr/src" || die
	fi
}
