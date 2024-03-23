# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_OPTIONAL=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit cmake distutils-r1 flag-o-matic

DESCRIPTION="assembly/assembler framework + bindings"
HOMEPAGE="https://www.keystone-engine.org/"

if [[ ${PV} == 9999* ]]; then
	EGIT_REPO_URI="https://github.com/keystone-engine/keystone.git"
	inherit git-r3
else
	SRC_URI="https://github.com/keystone-engine/keystone/archive/${PV/_rc/-rc}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
fi
S="${WORKDIR}"/${P/_rc/-rc}

LICENSE="GPL-2"
SLOT="0"

# Keep in sync with llvm/CMakeLists.txt
KEYSTONE_TARGETS="AArch64 ARM Hexagon Mips PowerPC Sparc SystemZ X86"

IUSE="python"

RDEPEND="
	python? ( ${PYTHON_DEPS} )
"
DEPEND="${RDEPEND}"
BDEPEND="
	python?
	(
		${DISTUTILS_DEPS}
		${PYTHON_DEPS}
	)
"

RESTRICT=test # only regression tests

REQUIRED_USE="
	python? ( ${PYTHON_REQUIRED_USE} )
"

# Upstream doesn't flag patch releases (bug 858395)
QA_PKGCONFIG_VERSION="$(ver_cut 1-2)"

wrap_python() {
	if use python; then
		pushd bindings/python >/dev/null || die
		distutils-r1_${1} "$@"
		popd >/dev/null || die
	fi
}

pkg_setup() {
	python_setup
}

src_prepare() {
	sed -i '/NOT uppercase_CMAKE_BUILD_TYPE MATCHES/ s/DEBUG/GENTOO|DEBUG/' \
		llvm/CMakeLists.txt || die
	cmake_src_prepare
	wrap_python ${FUNCNAME}
}

src_configure() {
	# ODR violations in bundled LLVM (bug #924866)
	filter-lto

	local libdir="$(get_libdir)"
	local mycmakeargs=(
		-DCMAKE_CONFIGURATION_TYPES="Gentoo"
		-DLLVM_LIBDIR_SUFFIX=${libdir#lib}
		-DBUILD_SHARED_LIBS=ON
		-DLLVM_TARGETS_TO_BUILD="${KEYSTONE_TARGETS// /;}"
		-DLLVM_HOST_TRIPLE="${CHOST}"
		-DPYTHON_EXECUTABLE="${PYTHON}"
	)

	cmake_src_configure
	wrap_python ${FUNCNAME}
}

src_compile() {
	cmake_src_compile
	wrap_python ${FUNCNAME}
}

src_install() {
	cmake_src_install
	wrap_python ${FUNCNAME}
}
