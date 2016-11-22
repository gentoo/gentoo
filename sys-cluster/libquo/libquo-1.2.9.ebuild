# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

FORTRAN_NEEDED=fortran
FORTRAN_STANDARD=90

inherit fortran-2

if [ "${PV}" = "9999" ]; then
	EGIT_REPO_URI="git://github.com/losalamos/${PN}.git https://github.com/losalamos/${PN}.git"
	inherit git-r3
	KEYWORDS=""
	AUTOTOOLS_AUTORECONF=1
else
	SRC_URI="http://losalamos.github.io/${PN}/dists/${P}.tar.gz"
	KEYWORDS="~amd64"
fi

DESCRIPTION="run-time tuning of process binding policies made easy"
HOMEPAGE="http://losalamos.github.io/libquo/"

LICENSE="BSD"
SLOT="0"
IUSE="fortran static-libs test"

DEPEND="
	virtual/mpi[fortran?]
	sys-process/numactl
	sys-apps/hwloc[numa,xml]
	"
RDEPEND="${DEPEND}"

src_configure() {
	econf CC=mpicc FC=$(usex fortran mpif90 false)
}
