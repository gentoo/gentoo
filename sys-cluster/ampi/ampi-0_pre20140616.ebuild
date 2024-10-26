# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="MPI library for algorithmic differentiation"
HOMEPAGE="https://www.mcs.anl.gov/~utke/AdjoinableMPI/AdjoinableMPIDox/index.html"
SRC_URI="https://dev.gentoo.org/~jauhien/distfiles/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 ~hppa ~ppc ppc64 ~riscv ~sparc x86"

RDEPEND="virtual/mpi"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/"${P}"-missing-include.patch )

src_prepare() {
	default
	eautoreconf
}
