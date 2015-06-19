# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/emboss/emboss-6.6.0.ebuild,v 1.2 2015/05/07 10:17:54 jlec Exp $

EAPI=5

AUTOTOOLS_AUTORECONF=1
inherit autotools-utils emboss-r1 eutils readme.gentoo

DESCRIPTION="The European Molecular Biology Open Software Suite - A sequence analysis package"
SRC_URI="ftp://emboss.open-bio.org/pub/EMBOSS/EMBOSS-${PV}.tar.gz"

KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE+=" minimal"
LICENSE+=" Apache-2.0 GPL-3+ CC-BY-3.0"

RDEPEND+=" !sys-devel/cons"
PDEPEND+="
	!minimal? (
		sci-biology/aaindex
		sci-biology/cutg
		sci-biology/primer3
		sci-biology/prints
		sci-biology/prosite
		sci-biology/rebase
		)"

S="${WORKDIR}"/EMBOSS-${PV}

DOCS=( ChangeLog AUTHORS NEWS THANKS FAQ )

PATCHES=(
	"${FILESDIR}"/${P}_fix-build-system.patch
	"${FILESDIR}"/${P}_FORTIFY_SOURCE-fix.patch
	"${FILESDIR}"/${P}_plplot-declarations.patch
	"${FILESDIR}"/${P}_qa-implicit-declarations.patch
)

src_install() {
	# Use autotools-utils_* to remove useless *.la files
	autotools-utils_src_install

	readme.gentoo_create_doc

	# Install env file for setting libplplot and acd files path.
	cat > 22emboss <<- EOF
		# ACD files location
		EMBOSS_ACDROOT="${EPREFIX}/usr/share/EMBOSS/acd"
		EMBOSS_DATA="${EPREFIX}/usr/share/EMBOSS/data"
	EOF
	doenvd 22emboss

	# Remove useless dummy files
	find "${ED}"/usr/share/EMBOSS -name dummyfile -delete || die "Failed to remove dummy files."

	# Move the provided codon files to a different directory. This will avoid
	# user confusion and file collisions on case-insensitive file systems (see
	# bug #115446). This change is documented in "README.gentoo".
	mv "${ED}"/usr/share/EMBOSS/data/CODONS{,.orig} || \
			die "Failed to move CODON directory."
}
