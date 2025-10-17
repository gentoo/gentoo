# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ROCM_VERSION=7.0
MY_PN=${PN%*-bin}
MY_P=${MY_PN}-${PV}
MY_tar=${MY_P}-manylinux_2_28_x86_64-rocm${ROCM_VERSION}-shared.tar.gz

DESCRIPTION="Ahead of Time (AOT) Triton Math Library (binary package)"
HOMEPAGE="https://github.com/ROCm/aotriton"

IMAGES_URI_BASE="https://github.com/ROCm/aotriton/releases/download/${PV}/aotriton-${PV}-images-amd"
SRC_URI="
	https://github.com/ROCm/${MY_PN}/releases/download/${PV}/${MY_tar}
	amdgpu_targets_gfx90a? ( ${IMAGES_URI_BASE}-gfx90a.tar.gz )
	amdgpu_targets_gfx942? ( ${IMAGES_URI_BASE}-gfx942.tar.gz )
	amdgpu_targets_gfx950? ( ${IMAGES_URI_BASE}-gfx950.tar.gz )

	amdgpu_targets_gfx1100? ( ${IMAGES_URI_BASE}-gfx11xx.tar.gz )
	amdgpu_targets_gfx1101? ( ${IMAGES_URI_BASE}-gfx11xx.tar.gz )
	amdgpu_targets_gfx1102? ( ${IMAGES_URI_BASE}-gfx11xx.tar.gz )
	amdgpu_targets_gfx1103? ( ${IMAGES_URI_BASE}-gfx11xx.tar.gz )
	amdgpu_targets_gfx1150? ( ${IMAGES_URI_BASE}-gfx11xx.tar.gz )
	amdgpu_targets_gfx1151? ( ${IMAGES_URI_BASE}-gfx11xx.tar.gz )

	amdgpu_targets_gfx1200? ( ${IMAGES_URI_BASE}-gfx120x.tar.gz )
	amdgpu_targets_gfx1201? ( ${IMAGES_URI_BASE}-gfx120x.tar.gz )
"
S="${WORKDIR}/${MY_PN}"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"

KEYWORDS="-* ~amd64"

IUSE_TARGETS=( gfx90a gfx942 gfx950 gfx1100 gfx1101 gfx1102 gfx1103 gfx1150 gfx1151 gfx1200 gfx1201 )
IUSE_TARGETS=( "${IUSE_TARGETS[@]/#/amdgpu_targets_}" )
IUSE="${IUSE_TARGETS[*]/#/+}"

RESTRICT="strip"
QA_PREBUILT="*"

RDEPEND="
	sys-libs/glibc
	sys-devel/gcc
	app-arch/xz-utils
	dev-util/hip:0/${ROCM_VERSION}
"

src_install() {
	doheader -r include/*

	insinto /usr/$(get_libdir)
	doins -r lib/*
}
