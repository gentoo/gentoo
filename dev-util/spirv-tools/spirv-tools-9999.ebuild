# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-multilib cmake-utils git-r3

DESCRIPTION="Provides an API and commands for processing SPIR-V modules"
HOMEPAGE="https://github.com/KhronosGroup/SPIRV-Tools"
EGIT_REPO_URI="https://github.com/KhronosGroup/SPIRV-Tools.git"
SRC_URI=""

LICENSE="Apache-2.0"
SLOT="0"
# Tests fail upon finding symbols that do not match a regular expression
# in the generated library. Easily hit with non-standard compiler flags
RESTRICT="test"

RDEPEND=""
DEPEND=">=dev-util/spirv-headers-1.3.4_pre20180917"

multilib_src_configure() {
	local mycmakeargs=(
		"-DSPIRV-Headers_SOURCE_DIR=/usr/"
	)

	cmake-utils_src_configure
}

multilib_src_install() {
	default

	# create a header file with the commit hash of the current revision
	# vulkan-tools needs this to build
	echo "${EGIT_VERSION}" > "${D}/usr/include/${PN}/${PN}-commit.h" || die
}
