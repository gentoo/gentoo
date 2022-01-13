# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="NVIDIA Accelerated Deep Learning on GPU library"
HOMEPAGE="https://developer.nvidia.com/cudnn"
SRC_URI="cuda11-5? ( cudnn-linux-x86_64-${PV}_cuda11.5-archive.tar.xz )"
S="${WORKDIR}/cudnn-linux-x86_64-${PV}_cuda11.5-archive"

LICENSE="NVIDIA-cuDNN"
SLOT="0/8"
KEYWORDS="~amd64 ~amd64-linux"
IUSE="+cuda11-5"
REQUIRED_USE="^^ ( cuda11-5 )"
RESTRICT="fetch"

RDEPEND="
	cuda11-5? ( =dev-util/nvidia-cuda-toolkit-11.5* )"

QA_PREBUILT="*"

src_install() {
	insinto /opt/cuda/targets/x86_64-linux
	doins -r include

	insinto /opt/cuda/targets/x86_64-linux/lib
	doins -r lib/.
}
