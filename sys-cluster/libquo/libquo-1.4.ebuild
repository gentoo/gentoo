# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

FORTRAN_NEEDED=fortran
FORTRAN_STANDARD=90

inherit fortran-2 autotools flag-o-matic

if [ "${PV}" = "9999" ]; then
	EGIT_REPO_URI="https://github.com/lanl/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://lanl.github.io/${PN}/dists/${P}.tar.gz"
	KEYWORDS="~amd64"
fi

DESCRIPTION="Run-time tuning of process binding policies made easy"
HOMEPAGE="https://lanl.github.io/libquo/"

LICENSE="BSD"
SLOT="0"
IUSE="fortran static-libs test"
RESTRICT="test" # Bug #867823: Need a real network interface or hostname set to localhost

DEPEND="
	virtual/mpi[fortran?]
	sys-process/numactl
	sys-apps/hwloc:=[numa(+),xml]
	"
RDEPEND="${DEPEND}"
BDEPEND="sys-apps/which"

PATCHES=(
	"${FILESDIR}"/${PN}-1.3.1-musl.patch
	"${FILESDIR}"/${P}-unbundle-hwloc.patch
)

src_prepare() {
	default
	rm -rf src/hwloc || die
	eautoreconf
}

src_configure() {
	append-fflags "-I${ESYSROOT}/usr/include"
	econf CC=mpicc FC=$(usex fortran mpif90 false)
}

src_install() {
	default
	find "${ED}" -type f -name '*.la' -delete || die
}
