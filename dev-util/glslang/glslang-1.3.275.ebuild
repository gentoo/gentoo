# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..12} )
inherit cmake-multilib python-any-r1

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/KhronosGroup/${PN}.git"
	inherit git-r3
else
	SNAPSHOT_COMMIT="vulkan-sdk-${PV}.0"
	SRC_URI="https://github.com/KhronosGroup/${PN}/archive/${SNAPSHOT_COMMIT}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 arm arm64 ~loong ppc ppc64 ~riscv x86"
	S="${WORKDIR}/${PN}-${SNAPSHOT_COMMIT}"
fi

DESCRIPTION="Khronos reference front-end for GLSL and ESSL, and sample SPIR-V generator"
HOMEPAGE="https://www.khronos.org/opengles/sdk/tools/Reference-Compiler/ https://github.com/KhronosGroup/glslang"

LICENSE="BSD"
SLOT="0/14"

# Bug 698850
RESTRICT="test"

BDEPEND="${PYTHON_DEPS}
	~dev-util/spirv-tools-${PV}:=[${MULTILIB_USEDEP}]
"

DEPEND="~dev-util/spirv-tools-${PV}:=[${MULTILIB_USEDEP}]"
RDEPEND="${DEPEND}"

multilib_src_configure() {
	local mycmakeargs=(
		-DENABLE_PCH=OFF
		-DALLOW_EXTERNAL_SPIRV_TOOLS=ON
	)
	cmake_src_configure
}
