# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="NVIDIA Accelerated Deep Learning on GPU library"
HOMEPAGE="https://developer.nvidia.com/cudnn"

SRC_URI="
	amd64? (
		https://developer.download.nvidia.com/compute/cudnn/redist/cudnn/linux-x86_64/cudnn-linux-x86_64-${PV}_cuda13-archive.tar.xz
	)
	arm64? (
		https://developer.download.nvidia.com/compute/cudnn/redist/cudnn/linux-sbsa/cudnn-linux-sbsa-${PV}_cuda13-archive.tar.xz
	)
"

S="${WORKDIR}"

LICENSE="NVIDIA-cuDNN"
SLOT="0/$(ver_cut 1-3)"
KEYWORDS="~amd64 ~arm64"
RESTRICT="bindist test"

RDEPEND="
	=dev-util/nvidia-cuda-toolkit-13*
"

QA_PREBUILT="/opt/cuda*/targets/*-linux/lib/*"

src_install() {
	local narch
	if use amd64; then
		narch="x86_64"
	elif use arm64; then
		narch="sbsa"
	fi

	# allow slotted install
	local CUDNN_PATH="${CUDNN_PATH:-${EPREFIX}/opt/cuda}"

	cd "${WORKDIR}/cudnn-linux-${narch}-${PV}_cuda13-archive" || die

	dodir "${CUDNN_PATH}/targets/${narch}-linux"
	mv \
		include lib \
		"${ED}${CUDNN_PATH}/targets/${narch}-linux" \
		|| die

	# Add include and lib symlinks
	dosym -r "${CUDNN_PATH}/targets/${narch}-linux/include" "${CUDNN_PATH}/include"
	dosym -r "${CUDNN_PATH}/targets/${narch}-linux/lib" "${CUDNN_PATH}/$(get_libdir)"

	find "${ED}/${CUDNN_PATH}" -empty -delete || die
}
