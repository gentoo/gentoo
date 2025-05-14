# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="NVIDIA Ray Tracing Engine"
HOMEPAGE="https://developer.nvidia.com/rtx/ray-tracing/optix"
SRC_URI="
	https://github.com/NVIDIA/optix-dev/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
"
S="${WORKDIR}/${PN}-dev-${PV}"

LICENSE="NVIDIA-SDK BSD"
SLOT="0/$(ver_cut 1)"
KEYWORDS="~amd64 ~arm64"
RESTRICT="test"

src_install() {
	insinto "/opt/${PN}"

	doins -r include/

	dodoc README.md
}
