# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-multilib

MY_PN="vid.stab"
DESCRIPTION="Video stabilization library"
HOMEPAGE="http://public.hronopik.de/vid.stab/"
SRC_URI="https://github.com/georgmartius/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cpu_flags_x86_sse2 openmp"
PATCHES=( "${FILESDIR}/${PN}-gentoo.diff" )
RDEPEND="openmp? ( sys-devel/gcc[openmp] )"
DEPEND="${RDEPEND}"
S="${WORKDIR}/${MY_PN}-${PV}"


src_configure() {
        use openmp && append-cppflags "-fopenmp -DUSE_OMP"
        use cpu_flags_x86_sse2 && append-cppflags "-DUSE_SSE2 -msse2 -ffast-math"
        cmake-multilib_src_configure
}
