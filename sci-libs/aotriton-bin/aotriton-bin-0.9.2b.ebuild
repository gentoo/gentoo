# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ROCM_VERSION=6.4

MY_PN=${PN%*-bin}
MY_P=${MY_PN}-${PV}
MY_tar=${MY_P}-manylinux_2_28_x86_64-rocm${ROCM_VERSION}-shared.tar.gz

DESCRIPTION="Ahead of Time (AOT) Triton Math Library (binary package)"
HOMEPAGE="https://github.com/ROCm/aotriton"
SRC_URI="https://github.com/ROCm/${MY_PN}/releases/download/${PV}/${MY_tar}"
S="${WORKDIR}/${MY_PN}"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"

KEYWORDS="-* ~amd64"

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
