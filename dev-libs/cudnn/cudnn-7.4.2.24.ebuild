# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CUDA_PV=10.0

DESCRIPTION="NVIDIA Accelerated Deep Learning on GPU library"
HOMEPAGE="https://developer.nvidia.com/cuDNN"

MY_PV_MAJOR=$(ver_cut 1-2)
SRC_URI="cudnn-${CUDA_PV}-linux-x64-v${PV}.tgz"

SLOT="0/7"
KEYWORDS="~amd64 ~amd64-linux"
RESTRICT="fetch"
LICENSE="NVIDIA-cuDNN"
QA_PREBUILT="*"

S="${WORKDIR}"

DEPEND="=dev-util/nvidia-cuda-toolkit-${CUDA_PV}*"
RDEPEND="${DEPEND}"

src_install() {
	insinto /opt
	doins -r *
}
