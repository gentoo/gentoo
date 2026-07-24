# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake fortran-2 flag-o-matic

MY_PN=${PN}-ng
MY_P=${MY_PN}-v${PV}

DESCRIPTION="Library for updating of QR and Cholesky decompositions"
HOMEPAGE="https://sourceforge.net/projects/qrupdate"
SRC_URI="https://gitlab.mpi-magdeburg.mpg.de/koehlerm/${MY_PN}/-/archive/v${PV}/${MY_P}.tar.bz2"

S="${WORKDIR}"/${MY_P}

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86"

RDEPEND="virtual/lapack"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${PN}-1.1.3-cmake.patch )

src_prepare() {
	# bug #878989 976683
	filter-lto

	cmake_src_prepare
}
