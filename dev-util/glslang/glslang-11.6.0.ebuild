# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_ECLASS="cmake"
PYTHON_COMPAT=( python3_{8..10} )
inherit cmake-multilib python-any-r1

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/KhronosGroup/${PN}.git"
	inherit git-r3
else
	SNAPSHOT_COMMIT="${PV}"
	SRC_URI="https://github.com/KhronosGroup/${PN}/archive/${SNAPSHOT_COMMIT}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ~arm ~arm64 ppc ~ppc64 ~riscv x86"
	S="${WORKDIR}/${PN}-${SNAPSHOT_COMMIT}"
fi

DESCRIPTION="Khronos reference front-end for GLSL and ESSL, and sample SPIR-V generator"
HOMEPAGE="https://www.khronos.org/opengles/sdk/tools/Reference-Compiler/ https://github.com/KhronosGroup/glslang"

LICENSE="BSD"
SLOT="0"

RDEPEND="!<media-libs/shaderc-2020.1"
BDEPEND="${PYTHON_DEPS}"

# Bug 698850
RESTRICT="test"
