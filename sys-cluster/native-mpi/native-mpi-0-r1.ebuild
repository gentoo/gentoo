# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Use native OS MPI in prefix environment"
HOMEPAGE="https://prefix.gentoo.org"
S="${WORKDIR}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""

src_install() {
	newenvd - 99mpi <<-_EOF_
		MPI_CC=$(tc-getCC)
		MPI_CXX=$(tc-getCXX)
		MPI_FC=$(tc-getFC)
		MPI_F90=$(tc-getFC)
		HPMPI_F77=$(tc-getFC)
	_EOF_
}

pkg_postinst() {
	einfo
	einfo "Please read and edit ${EROOT}/etc/env.d/99mpi"
	einfo "to add needed values for your os-mpi implentation"
	einfo
}
