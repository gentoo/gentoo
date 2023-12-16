# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools fortran-2 toolchain-funcs

DESCRIPTION="Arnoldi package library to solve large scale eigenvalue problems"
HOMEPAGE="http://www.caam.rice.edu/software/ARPACK/ https://github.com/opencollab/arpack-ng"

if [[ ${PV} == *9999 ]]; then
	EGIT_REPO_URI="https://github.com/opencollab/arpack-ng"
	inherit git-r3
else
	SRC_URI="https://github.com/opencollab/${PN}-ng/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~ppc ppc64 ~riscv ~s390 ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
	S="${WORKDIR}/${PN}-ng-${PV}"
fi

LICENSE="BSD"
SLOT="0"
IUSE="examples mpi"

RDEPEND="
	virtual/blas
	virtual/lapack
	mpi? ( virtual/mpi[fortran] )
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-3.9.1-bashism-configure.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--disable-static \
		--enable-icb \
		--with-blas="$($(tc-getPKG_CONFIG) --libs blas)" \
		--with-lapack="$($(tc-getPKG_CONFIG) --libs lapack)" \
		$(use_enable mpi)
}

src_install() {
	default

	dodoc DOCUMENTS/*.doc
	newdoc DOCUMENTS/README README.doc
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
