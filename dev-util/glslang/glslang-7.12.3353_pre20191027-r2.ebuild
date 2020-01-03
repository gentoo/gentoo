# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=(python{3_6,3_7})

inherit cmake-multilib cmake-utils python-any-r1

SNAPSHOT_COMMIT="b131630e7c749a5dc19faa458024260c71fb170f"
SRC_URI="https://github.com/KhronosGroup/${PN}/archive/${SNAPSHOT_COMMIT}.tar.gz -> ${P}.tar.gz"
KEYWORDS="amd64 x86"
S="${WORKDIR}/glslang-${SNAPSHOT_COMMIT}"

DESCRIPTION="Khronos reference front-end for GLSL and ESSL, and sample SPIR-V generator"
HOMEPAGE="https://www.khronos.org/opengles/sdk/tools/Reference-Compiler/"

LICENSE="BSD"
SLOT="0"

PATCHES=(
	"${FILESDIR}/${P}-fix-relative-includes.patch"
	"${FILESDIR}/${PN}-Respect-CMAKE_INSTALL_LIBDIR-in-installed-CMake-files.patch"
	)

RDEPEND="!<media-libs/shaderc-2019-r1"
BDEPEND="${PYTHON_DEPS}"

# Bug 698850
RESTRICT="test"
