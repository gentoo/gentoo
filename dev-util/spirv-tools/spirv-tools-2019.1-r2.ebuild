# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7} )

inherit cmake-multilib cmake-utils python-any-r1

DESCRIPTION="Provides an API and commands for processing SPIR-V modules"
HOMEPAGE="https://github.com/KhronosGroup/SPIRV-Tools"
SRC_URI="https://github.com/KhronosGroup/SPIRV-Tools/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
# Tests fail upon finding symbols that do not match a regular expression
# in the generated library. Easily hit with non-standard compiler flags
RESTRICT="test"

COMMON_DEPEND=">=dev-util/spirv-headers-1.3.4_pre20190302"
DEPEND="${COMMON_DEPEND}"
RDEPEND=""
BDEPEND="${PYTHON_DEPS}
	${COMMON_DEPEND}"

EGIT_COMMIT="2297d4a3dfcbfd2a8b4312fab055ae26e3289fd3"
S="${WORKDIR}/SPIRV-Tools-${PV}"
PATCHES=( "${FILESDIR}"/${PN}-2019.1-Fix-vertex-instrumentation.patch )

multilib_src_configure() {
	local mycmakeargs=(
		"-DSPIRV-Headers_SOURCE_DIR=/usr/"
		"-DSPIRV_WERROR=OFF"
	)

	cmake-utils_src_configure
}

multilib_src_install() {
	cmake-utils_src_install
	echo "${EGIT_COMMIT}" > "${PN}-commit.h" || die
	insinto /usr/include/"${PN}"
	doins  "${PN}-commit.h"
}
