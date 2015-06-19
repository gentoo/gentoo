# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/abyss/abyss-1.3.3.ebuild,v 1.5 2013/08/11 14:55:22 jlec Exp $

EAPI="4"

inherit autotools eutils toolchain-funcs

DESCRIPTION="Assembly By Short Sequences - a de novo, parallel, paired-end sequence assembler"
HOMEPAGE="http://www.bcgsc.ca/platform/bioinfo/software/abyss/"
SRC_URI="http://www.bcgsc.ca/downloads/abyss/${P}.tar.gz"

LICENSE="abyss"
SLOT="0"
IUSE="+mpi openmp"
KEYWORDS="amd64 x86"

DEPEND="
	dev-cpp/sparsehash
	mpi? ( virtual/mpi )"
RDEPEND="${DEPEND}"

# todo: --enable-maxk=N configure option
# todo: fix automagic mpi toggling

src_prepare() {
	tc-export AR
	epatch \
		"${FILESDIR}"/${P}-gcc-4.7.patch \
		"${FILESDIR}"/${P}-ac_prog_ar.patch

	sed -i -e "s/-Werror//" configure.ac || die #365195
	sed -i -e "/dist_pkgdoc_DATA/d" Makefile.am || die
	eautoreconf
}

src_configure() {
	econf \
		--docdir="${EPREFIX}/usr/share/doc/${PF}" \
		$(use_enable openmp)
}
