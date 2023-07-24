# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Machine-readable files for the SPIR-V Registry"
HOMEPAGE="https://registry.khronos.org/SPIR-V/"
EGIT_COMMIT="sdk-${PV}"
SRC_URI="https://github.com/KhronosGroup/SPIRV-Headers/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/SPIRV-Headers-${EGIT_COMMIT}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"
