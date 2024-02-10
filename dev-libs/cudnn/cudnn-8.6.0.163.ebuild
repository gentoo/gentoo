# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

BASE_V="$(ver_cut 0-3)"
# supports 11.x but URL has a specific version number
CUDA_MA="11"
CUDA_MI="8"
CUDA_V="${CUDA_MA}.${CUDA_MI}"

DESCRIPTION="NVIDIA Accelerated Deep Learning on GPU library"
HOMEPAGE="https://developer.nvidia.com/cudnn"
SRC_URI="https://developer.download.nvidia.com/compute/redist/cudnn/v${BASE_V}/local_installers/${CUDA_V}/cudnn-linux-x86_64-${PV}_cuda${CUDA_MA}-archive.tar.xz"
S="${WORKDIR}/cudnn-linux-x86_64-${PV}_cuda${CUDA_MA}-archive"

LICENSE="NVIDIA-cuDNN"
SLOT="0/8"
KEYWORDS="~amd64 ~amd64-linux"
RESTRICT="mirror"

RDEPEND="=dev-util/nvidia-cuda-toolkit-11*"

QA_PREBUILT="/opt/cuda/targets/x86_64-linux/lib/*"

src_install() {
	insinto /opt/cuda/targets/x86_64-linux
	doins -r include lib
}
