# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN=SPIRV-Tools
CMAKE_ECLASS="cmake"
PYTHON_COMPAT=( python3_{7,8,9} )
inherit cmake-multilib python-any-r1

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/KhronosGroup/${MY_PN}.git"
	inherit git-r3
else
	EGIT_COMMIT="1fbed83c8aab8517d821fcb4164c08567951938f"
	SRC_URI="https://github.com/KhronosGroup/${MY_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 arm ~arm64 ppc ppc64 ~riscv x86"
	S="${WORKDIR}"/${MY_PN}-${EGIT_COMMIT}
fi

DESCRIPTION="Provides an API and commands for processing SPIR-V modules"
HOMEPAGE="https://github.com/KhronosGroup/SPIRV-Tools"

LICENSE="Apache-2.0"
SLOT="0"
# Tests fail upon finding symbols that do not match a regular expression
# in the generated library. Easily hit with non-standard compiler flags
RESTRICT="test"
COMMON_DEPEND=">=dev-util/spirv-headers-20210817"
DEPEND="${COMMON_DEPEND}"
RDEPEND=""
BDEPEND="${PYTHON_DEPS}
	${COMMON_DEPEND}"

multilib_src_configure() {
	local mycmakeargs=(
		"-DSPIRV-Headers_SOURCE_DIR=${ESYSROOT}/usr/"
		"-DSPIRV_WERROR=OFF"
		"-DSPIRV_TOOLS_BUILD_STATIC=OFF"
		"-DBUILD_SHARED_LIBS=ON"
	)

	cmake_src_configure
}
