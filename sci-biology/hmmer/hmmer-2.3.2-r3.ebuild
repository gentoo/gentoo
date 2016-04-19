# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Sequence analysis using profile hidden Markov models"
LICENSE="GPL-2"
HOMEPAGE="http://hmmer.janelia.org/"
SRC_URI="ftp://ftp.genetics.wustl.edu/pub/eddy/${PN}/${PV}/${P}.tar.gz"

SLOT="0"
IUSE="threads test"
KEYWORDS="~alpha amd64 ia64 ~ppc ppc64 ~sparc x86"

DEPEND=""
RDEPEND=""

src_configure() {
	econf \
		--host=${CHOST} \
		--prefix="${D}"/usr \
		--exec_prefix="${D}"/usr \
		--mandir="${D}"/usr/share/man \
		--enable-lfs \
		$(use_enable threads)
}

src_install() {
	emake DESTDIR="${D}" install

	pushd src >/dev/null || die
	dolib libhmmer.a
	insinto /usr/include/hmmer
	doins *.h
	popd >/dev/null || die

	pushd squid >/dev/null || die
	dobin afetch alistat compalign compstruct revcomp seqstat seqsplit sfetch shuffle sreformat sindex weight translate
	dolib libsquid.a
	insinto /usr/include/hmmer
	doins *.h
	popd >/dev/null || die

	dodoc NOTES
	newdoc 00README README
	insinto /usr/share/doc/${PF}
	doins Userguide.pdf
}

src_test() {
	emake check
}
