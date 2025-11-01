# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MAJOR="$(ver_cut 1)"

CMAKE_MAKEFILE_GENERATOR="emake"
PYTHON_COMPAT=( python3_{12..14} )

inherit check-reqs cmake flag-o-matic python-any-r1

DESCRIPTION="The Lean Theorem Prover"
HOMEPAGE="https://leanprover-community.github.io/
	https://github.com/leanprover/lean4/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/leanprover/${PN}${MAJOR}"
else
	SRC_URI="https://github.com/leanprover/${PN}${MAJOR}/archive/refs/tags/v${PV/_/-}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}/${PN}${MAJOR}-${PV/_/-}"

	KEYWORDS="~amd64"
fi

LICENSE="Apache-2.0"
SLOT="0/${MAJOR}"
IUSE="debug source"

RDEPEND="
	dev-libs/gmp:=
	dev-libs/libuv:=
	sci-mathematics/cadical
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	${PYTHON_DEPS}
"

CHECKREQS_DISK_BUILD="4G"
CHECKREQS_DISK_USR="2G"

# Built by lean's build tool.
QA_FLAGS_IGNORED="
usr/lib/lean/libInit_shared.so
usr/lib/lean/libleanshared_1.so
"

pkg_setup() {
	python-any-r1_pkg_setup
}

src_prepare() {
	filter-lto

	sed -e "s|-O[23]|${CFLAGS}|g" -i ./src/CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	local CMAKE_BUILD_TYPE=""

	if use debug ; then
		CMAKE_BUILD_TYPE="Debug"
	else
		CMAKE_BUILD_TYPE="Release"
	fi

	local -a mycmakeargs=(
		-DCCACHE="OFF"
		-DGIT_HASH="OFF"

		-DUSE_MIMALLOC="OFF"
		-DINSTALL_LICENSE="OFF"
		-DINSTALL_CADICAL="OFF"

		-DLEAN_EXTRA_CXX_FLAGS="${CXXFLAGS}"
		-DLEAN_EXTRA_LINKER_FLAGS="${LDFLAGS}"
		-DLEAN_EXTRA_MAKE_OPTS="-s 262144"
		-DLEANC_EXTRA_FLAGS="${CFLAGS}"
	)
	cmake_src_configure
}

src_compile() {
	ulimit -s 30000000 || eerror "Failed to set required ulimit. Build may fail!"

	cmake_src_compile
}

src_install() {
	cmake_src_install

	if ! use source ; then
		rm -r "${ED}/usr/src" || die
	fi
}
