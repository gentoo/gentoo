# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A High-Performance CUDA Library for Sparse Matrix-Matrix Multiplication"
HOMEPAGE="https://docs.nvidia.com/cuda/cusparselt/index.html"
SRC_URI="
	amd64? (
		https://developer.download.nvidia.com/compute/cusparselt/redist/libcusparse_lt/linux-x86_64/libcusparse_lt-linux-x86_64-${PV}-archive.tar.xz
	)
	arm64? (
		https://developer.download.nvidia.com/compute/cusparselt/redist/libcusparse_lt/linux-sbsa/libcusparse_lt-linux-sbsa-${PV}-archive.tar.xz
	)
"

LICENSE="NVIDIA-SDK"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~amd64-linux ~arm64-linux"
RESTRICT="bindist mirror test"

RDEPEND="
	dev-util/nvidia-cuda-toolkit
"

QA_PREBUILT="/opt/cuda*/targets/*-linux/lib/*"

src_prepare(){
	:
}

src_configure(){
	:
}

src_compile(){
	:
}

src_install() {
	local narch
	if use amd64; then
		narch="x86_64"
	elif use arm64; then
		narch="sbsa"
	fi

	# allow slotted install
	mv \
		include lib \
		"${ED}${CUDNN_PATH:-${EPREFIX}/opt/cuda}/targets/${narch}-linux" \
		|| die
}
