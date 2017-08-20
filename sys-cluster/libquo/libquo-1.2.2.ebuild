# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit autotools-utils

DESCRIPTION="run-time tuning of process binding policies made easy"
HOMEPAGE="https://lanl.github.io/libquo/"
SRC_URI="https://lanl.github.io/${PN}/dists/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="fortran"

DEPEND="
	virtual/mpi[fortran?]
	sys-process/numactl
	sys-apps/hwloc[numa,xml]
	"
RDEPEND="${DEPEND}"

AUTOTOOLS_IN_SOURCE_BUILD=1

src_configure() {
	autotools-utils_src_configure CC=mpicc FC=$(usex fortran mpif90 false)
}
