# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Identify motifs, conserved regions, in DNA or protein sequences"
HOMEPAGE="http://bayesweb.wadsworth.org/gibbs/gibbs.html"
SRC_URI="mirror://gentoo/gibbs-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="mpi"

DEPEND="
	mpi? (
		virtual/mpi
		sys-cluster/mpe2
	)"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/${PN}-3.1-fix-CFLAGS.patch )

src_prepare() {
	default
	mv configure.{in,ac} || die
	eautoreconf
}

src_configure() {
	use mpi && export CC=mpicc
	econf $(use_enable mpi)
}

src_install() {
	default

	exeinto /usr/$(get_libdir)/${PN}
	doexe *.pl
}

pkg_postinst() {
	einfo "Supplementary Perl scripts for Gibbs have been installed into ${EROOT}/usr/$(get_libdir)/${PN}."
	einfo "These scripts require installation of sci-biology/bioperl."
}
