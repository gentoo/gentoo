# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit eutils flag-o-matic python-any-r1 toolchain-funcs

DESCRIPTION="Scalable Library for Eigenvalue Problem Computations"
HOMEPAGE="http://slepc.upv.es/"
SRC_URI="http://slepc.upv.es/download/distrib/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="complex-scalars doc mpi"

RDEPEND="
	=sci-mathematics/petsc-$(ver_cut 1-2)*:=[mpi=,complex-scalars=]
	sci-libs/arpack[mpi=]
	mpi? ( virtual/mpi )
"

DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	virtual/pkgconfig
	dev-util/cmake
"

MAKEOPTS="${MAKEOPTS} V=1"

src_configure() {
	# *sigh*
	addpredict "${PETSC_DIR}"/.nagged

	# Make sure that the environment is set up correctly:
	unset PETSC_DIR
	unset PETSC_ARCH
	source "${EPREFIX}"/etc/env.d/99petsc
	export PETSC_DIR
	export PETSC_ARCH
	export SLEPC_DIR="${S}"

	# configure is a custom python script and doesn't want to have default
	# configure arguments that we set with econf
	./configure \
		--prefix="${EPREFIX}/usr/$(get_libdir)/slepc" \
		--with-arpack=1 \
		--with-arpack-dir="${EPREFIX}/usr/$(get_libdir)" \
		--with-arpack-lib="$(usex mpi "-lparpack,-larpack" "-larpack")"
}

src_install() {
	emake DESTDIR="${ED}" install

	# add PETSC_DIR to environmental variables
	cat >> 99slepc <<- EOF
		SLEPC_DIR=${EPREFIX}/usr/$(get_libdir)/slepc
		LDPATH=${EPREFIX}/usr/$(get_libdir)/slepc/lib
	EOF
	doenvd 99slepc

	if use doc ; then
		dodoc docs/slepc.pdf
		docinto html
		dodoc -r docs/*.html docs/manualpages
	fi
}
