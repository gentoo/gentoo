# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

AUTOTOOLS_AUTORECONF=yes

inherit autotools-utils multilib

DESCRIPTION="Identify motifs, conserved regions, in DNA or protein sequences"
HOMEPAGE="http://bayesweb.wadsworth.org/gibbs/gibbs.html"
SRC_URI="mirror://gentoo/gibbs-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE="mpi"
KEYWORDS="amd64 x86"

DEPEND="
	mpi? (
		virtual/mpi
		sys-cluster/mpe2 )"
RDEPEND="${DEPEND}"

src_prepare() {
	sed \
		-e 's/CFLAGS="$OPTFLAGS/CFLAGS="$CFLAGS $OPTFLAGS/' \
		-e 's/-Werror//' \
		-i configure.in || die
	autotools-utils_src_prepare
}

src_configure() {
	if use mpi; then export CC=mpicc; fi
	local myeconfargs=( $(use_enable mpi) )
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install
	exeinto /usr/$(get_libdir)/${PN}
	doexe *.pl
	dodoc README ChangeLog
}

pkg_postinst() {
	einfo "Supplementary Perl scripts for Gibbs have been installed into /usr/$(get_libdir)/${PN}."
	einfo "These scripts require installation of sci-biology/bioperl."
}
