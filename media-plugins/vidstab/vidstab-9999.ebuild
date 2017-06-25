# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3 cmake-multilib

MY_PN="vid.stab"
DESCRIPTION="Video stabilization library"
HOMEPAGE="http://public.hronopik.de/vid.stab/"
EGIT_REPO_URI=( {https,git}://github.com/georgmartius/${MY_PN}.git )
#EGIT_COMMIT="v1.1.0"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS=""
IUSE="cpu_flags_x86_sse2 openmp"
PATCHES=( "${FILESDIR}/${PN}-gentoo.diff" )
RDEPEND="openmp? ( sys-devel/gcc[openmp] )"
DEPEND="${RDEPEND}"

src_configure() {
        if use openmp; then
            tc-check-openmp
            append-cppflags "-DUSE_OMP"
            append-cflags -fopenmp
        fi
        if use cpu_flags_x86_sse2; then
            append-cppflags "-DUSE_SSE2"
            append-cflags "-msse2"
        fi
        cmake-multilib_src_configure
}
