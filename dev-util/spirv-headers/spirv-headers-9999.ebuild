# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils git-r3

DESCRIPTION="Machine-readable files for the SPIR-V Registry"
HOMEPAGE="https://www.khronos.org/registry/spir-v/"
EGIT_REPO_URI="https://github.com/KhronosGroup/SPIRV-Headers.git"
SRC_URI=""

LICENSE="MIT"
SLOT="0"

PATCHES=( "${FILESDIR}"/${PN}-Get-rid-of-custom-target.patch )
