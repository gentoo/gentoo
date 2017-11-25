# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-multilib cmake-utils vcs-snapshot

SNAPSHOT_COMMIT="ac3707921ed313eaba1c206e8113b85fef054c34"
SRC_URI="https://github.com/KhronosGroup/${PN}/archive/${SNAPSHOT_COMMIT}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

DESCRIPTION="Khronos reference front-end for GLSL and ESSL, and sample SPIR-V generator"
HOMEPAGE="https://www.khronos.org/opengles/sdk/tools/Reference-Compiler/"

LICENSE="BSD"
SLOT="0"
