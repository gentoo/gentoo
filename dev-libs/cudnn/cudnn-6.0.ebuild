# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CUDA_PV=8.0

DESCRIPTION="NVIDIA Accelerated Deep Learning on GPU library"
HOMEPAGE="https://developer.nvidia.com/cuDNN"
SRC_URI="cudnn-${CUDA_PV}-linux-x64-v${PV}.tgz"

SLOT="0/6"
KEYWORDS="~amd64 ~amd64-linux"
RESTRICT="fetch"
LICENSE="NVIDIA-cuDNN"

S="${WORKDIR}"

DEPENDS="=dev-util/nvidia-cuda-toolkit-${CUDA_PV}*"
RDEPENDS="${DEPENDS}"

src_install() {
	insinto /opt
	doins -r *
}
