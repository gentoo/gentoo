# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

DESCRIPTION="Machine-readable files for the SPIR-V Registry"
HOMEPAGE="https://www.khronos.org/registry/spir-v/"
EGIT_COMMIT="${PV}"
SRC_URI="https://github.com/KhronosGroup/SPIRV-Headers/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 arm arm64 ~ppc ppc64 ~riscv x86"

S="${WORKDIR}/SPIRV-Headers-${EGIT_COMMIT}"
