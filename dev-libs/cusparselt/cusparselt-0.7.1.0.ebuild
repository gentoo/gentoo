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

# The package contains a directory with the archive name minus the extension.
# So to handle arm64/amd64 we use WORKDIR here
S="${WORKDIR}"

LICENSE="NVIDIA-SDK-v2020.10.12 NVIDIA-cuSPARSELt-v2020.10.12"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
RESTRICT="bindist mirror test"

QA_PREBUILT="/opt/cuda*/targets/*-linux/lib/*"

pkg_setup() {
	if use amd64; then
		export narch="x86_64"
	elif use arm64; then
		export narch="sbsa"
	fi
}

src_prepare() {
	cd "libcusparse_lt-linux-${narch}-${PV}-archive" || die

	eapply_user
}

src_configure() {
	:
}

src_compile() {
	:
}

src_install() {
	cd "libcusparse_lt-linux-${narch}-${PV}-archive" || die

	# allow slotted install
	mkdir -vp "${ED}${CUDNN_PATH:-${EPREFIX}/opt/cuda}/targets/${narch}-linux" || die
	mv \
		include lib \
		"${ED}${CUDNN_PATH:-${EPREFIX}/opt/cuda}/targets/${narch}-linux" \
		|| die
}
