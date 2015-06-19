# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/prosite/prosite-20.52.ebuild,v 1.5 2011/12/05 17:56:42 jlec Exp $

DESCRIPTION="A protein families and domains database"
HOMEPAGE="http://ca.expasy.org/prosite"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

SLOT="0"
LICENSE="swiss-prot"
# Minimal build keeps only the indexed files (if applicable) and the
# documentation. The non-indexed database is not installed.
IUSE="emboss minimal"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris ~x86-solaris"

DEPEND="emboss? ( sci-biology/emboss )"
RDEPEND="${DEPEND}"

src_compile() {
	if use emboss; then
		mkdir PROSITE
		echo
		einfo "Indexing PROSITE for usage with EMBOSS."
		EMBOSS_DATA="." prosextract -auto -prositedir "${S}" || die \
			"Indexing PROSITE failed."
		echo
	fi
}

src_install() {
	if ! use minimal; then
		insinto /usr/share/${PN}
		doins *.{doc,dat} || die "Installing raw database failed."
	fi
	insinto /usr/share/doc/${PF}
	doins *.pdf || die "PDF documentation installation failed."
	if use emboss; then
		insinto /usr/share/EMBOSS/data/PROSITE
		doins PROSITE/* || die "Installing EMBOSS data files failed."
	fi
}
