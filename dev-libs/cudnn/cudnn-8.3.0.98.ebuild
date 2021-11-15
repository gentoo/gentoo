# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="NVIDIA Accelerated Deep Learning on GPU library"
HOMEPAGE="https://developer.nvidia.com/cuDNN"
SRC_URI="
	cuda10-2? ( cudnn-10.2-linux-x64-v${PV}.tgz )
	cuda11-5? ( cudnn-11.5-linux-x64-v${PV}.tgz )"
S="${WORKDIR}"

LICENSE="NVIDIA-cuDNN"
SLOT="0/8"
KEYWORDS="~amd64 ~amd64-linux"
IUSE="cuda10-2 +cuda11-5"
REQUIRED_USE="^^ ( cuda10-2 cuda11-5 )"
RESTRICT="fetch"

RDEPEND="
	cuda10-2? ( =dev-util/nvidia-cuda-toolkit-10.2* )
	cuda11-5? ( =dev-util/nvidia-cuda-toolkit-11.5* )"

QA_PREBUILT="*"

src_install() {
	insinto /opt/cuda
	doins cuda/NVIDIA_SLA_cuDNN_Support.txt

	insinto /opt/cuda/targets/x86_64-linux
	doins -r cuda/include

	insinto /opt/cuda/targets/x86_64-linux/lib
	doins -r cuda/lib64/.
}
