# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-multilib cmake-utils

DESCRIPTION="Provides an API and commands for processing SPIR-V modules"
HOMEPAGE="https://github.com/KhronosGroup/SPIRV-Tools"
SRC_URI="https://github.com/KhronosGroup/SPIRV-Tools/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# Tests fail upon finding symbols that do not match a regular expression
# in the generated library. Easily hit with non-standard compiler flags
RESTRICT="test"

RDEPEND=""
DEPEND=">=dev-util/spirv-headers-1.3.1_pre20180710"
EGIT_COMMIT="f508896d6487d09f5c9a2a3835595446fec0791a"
S="${WORKDIR}/SPIRV-Tools-${PV}"

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
