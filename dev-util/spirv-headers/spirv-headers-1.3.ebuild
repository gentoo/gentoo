# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Machine-readable files for the SPIR-V Registry"
HOMEPAGE="https://www.khronos.org/registry/spir-v/"
EGIT_COMMIT="02ffc719aa9f9c1dce5ce05743fb1afe6cbf17ea"
SRC_URI="https://github.com/KhronosGroup/SPIRV-Headers/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

PATCHES=( "${FILESDIR}"/${PN}-Get-rid-of-custom-target.patch )

S="${WORKDIR}/SPIRV-Headers-${EGIT_COMMIT}"
