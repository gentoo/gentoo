# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools fortran-2 toolchain-funcs

DESCRIPTION="Arnoldi package library to solve large scale eigenvalue problems"
HOMEPAGE="http://www.caam.rice.edu/software/ARPACK/ https://github.com/opencollab/arpack-ng"
SRC_URI="
	https://github.com/opencollab/${PN}-ng/archive/${PV}.tar.gz -> ${P}.tar.gz
	doc? (
		http://www.caam.rice.edu/software/ARPACK/SRC/ug.ps.gz
		http://www.caam.rice.edu/software/ARPACK/DOCS/tutorial.ps.gz )"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ~ia64 ppc ppc64 ~riscv ~s390 ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="doc examples mpi"

RDEPEND="
	virtual/blas
	virtual/lapack
	mpi? ( virtual/mpi[fortran] )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/${PN}-ng-${PV}"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--disable-static \
		--with-blas="$($(tc-getPKG_CONFIG) --libs blas)" \
		--with-lapack="$($(tc-getPKG_CONFIG) --libs lapack)" \
		$(use_enable mpi)
}

src_install() {
	default

	dodoc DOCUMENTS/*.doc
	newdoc DOCUMENTS/README README.doc
	use doc && dodoc "${WORKDIR}"/*.ps
	if use examples; then
		dodoc -r EXAMPLES
		if use mpi; then
			docinto EXAMPLES/PARPACK
			dodoc -r PARPACK/EXAMPLES/MPI
		fi
	fi

	# no static archives
	find "${ED}" -name '*.la' -delete || die
}
