# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=(python{3_6,3_7})

inherit cmake-multilib cmake-utils python-any-r1 git-r3

EGIT_REPO_URI="https://github.com/KhronosGroup/glslang.git"
SRC_URI=""

DESCRIPTION="Khronos reference front-end for GLSL and ESSL, and sample SPIR-V generator"
HOMEPAGE="https://www.khronos.org/opengles/sdk/tools/Reference-Compiler/"

LICENSE="BSD"
SLOT="0"

PATCHES=( "${FILESDIR}/${P}-fix-relative-includes.patch" )

RDEPEND="!<media-libs/shaderc-2019-r1"
BDEPEND="${PYTHON_DEPS}"

# Bug 698850
RESTRICT="test"
