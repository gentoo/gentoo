# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Use native OS MPI in prefix environment"
HOMEPAGE="https://prefix.gentoo.org"
SRC_URI=""

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64-linux ~x86-linux"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}"

src_install() {
	cat >> "${T}"/99mpi <<- EOF || die
	MPI_CC=gcc
	MPI_CXX=g++
	MPI_FC=gfortran
	MPI_F90=gfortran
	HPMPI_F77=gfortran
	EOF
	doenvd "${T}"/99mpi
}

pkg_postinst() {
	einfo
	einfo "Please read and edit ${EPREFIX}/etc/env.d/99mpi"
	einfo "to add needed values for your os-mpi implentation"
	einfo
}
