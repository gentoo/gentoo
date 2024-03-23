# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake optfeature toolchain-funcs xdg

DESCRIPTION="A monitor of resources"
HOMEPAGE="https://github.com/aristocratos/btop"
SRC_URI="
	https://github.com/aristocratos/btop/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~m68k ~mips ~ppc ppc64 ~riscv ~x86"

pkg_setup() {
	if [[ "${MERGE_TYPE}" != "binary" ]]; then
		if tc-is-clang ; then
			if [[ "$(clang-major-version)" -lt 16 ]]; then
				die "sys-process/btop requires >=sys-devel/clang-16.0.0 to build."
			fi
		elif ! tc-is-gcc ; then
			die "$(tc-getCXX) is not a supported compiler. Please use sys-devel/gcc or >=sys-devel/clang-16.0.0 instead."
		fi
	fi
}

src_configure() {
	local mycmakeargs=(
		-DBTOP_GPU=true
		-DBTOP_RSMI_STATIC=false
		# Fortification can be set in CXXFLAGS instead
		-DBTOP_FORTIFY=false
	)
	cmake_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst

	optfeature "GPU monitoring support (Radeon GPUs)" dev-util/rocm-smi
	optfeature "GPU monitoring support (NVIDIA GPUs)" x11-drivers/nvidia-drivers
}
