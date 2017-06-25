# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs flag-o-matic cmake-multilib

MY_PN="vid.stab"
DESCRIPTION="Video stabilization library"
HOMEPAGE="http://public.hronopik.de/vid.stab/"
SRC_URI="https://github.com/georgmartius/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cpu_flags_x86_sse2 openmp"

S="${WORKDIR}/${MY_PN}-${PV}"
PATCHES=( "${FILESDIR}/${PN}-gentoo.diff" )
RDEPEND=""
DEPEND="${RDEPEND}"

pkg_pretend() {
        [[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
        [[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_configure() {
        if use openmp; then
            append-cppflags "-DUSE_OMP"
            append-cflags -fopenmp
        fi
        if use cpu_flags_x86_sse2; then
            append-cppflags "-DUSE_SSE2"
            append-cflags "-msse2"
        fi
        cmake-multilib_src_configure
}
