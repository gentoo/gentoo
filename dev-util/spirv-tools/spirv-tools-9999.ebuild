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

RDEPEND=""
DEPEND="dev-util/spirv-headers"

multilib_src_configure() {
	local mycmakeargs=(
		"-DSPIRV-Headers_SOURCE_DIR=/usr/"
	)

	cmake-utils_src_configure
}
