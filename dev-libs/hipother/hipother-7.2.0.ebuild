# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="ROCclr runtime implementation for non-AMD HIP platforms, like NVIDIA"
HOMEPAGE="https://github.com/ROCm/rocm-systems/tree/develop/projects/hipother"
SRC_URI="https://github.com/ROCm/rocm-systems/releases/download/rocm-${PV}/${PN}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"

src_install() {
	insinto /usr/include
	doins -r hipnv/include/hip
}
