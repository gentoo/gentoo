# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..12} )
inherit cmake-multilib python-any-r1

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/KhronosGroup/${PN}.git"
	inherit git-r3
else
	SNAPSHOT_COMMIT="sdk-${PV}.0"
	SRC_URI="https://github.com/KhronosGroup/${PN}/archive/${SNAPSHOT_COMMIT}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 arm arm64 ~loong ~ppc ppc64 ~riscv x86"
	S="${WORKDIR}/${PN}-${SNAPSHOT_COMMIT}"
fi

DESCRIPTION="Khronos reference front-end for GLSL and ESSL, and sample SPIR-V generator"
HOMEPAGE="https://www.khronos.org/opengles/sdk/tools/Reference-Compiler/ https://github.com/KhronosGroup/glslang"

LICENSE="BSD"
SLOT="0/12"

# Bug 698850
RESTRICT="test"

BDEPEND="${PYTHON_DEPS}"

PATCHES=( "${FILESDIR}/${PN}-1.3.236-Install-static-libs.patch" )

multilib_src_configure() {
	local mycmakeargs=(
		-DENABLE_PCH=OFF
	)
	cmake_src_configure
}
