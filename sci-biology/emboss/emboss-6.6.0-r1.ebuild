# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EBO_EAUTORECONF=1

inherit emboss-r2 readme.gentoo-r1

DESCRIPTION="The European Molecular Biology Open Software Suite - A sequence analysis package"
SRC_URI="ftp://emboss.open-bio.org/pub/${PN^^}/${P^^}.tar.gz"

KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="minimal"
LICENSE+=" Apache-2.0 GPL-3+ CC-BY-3.0"

RDEPEND="
	!games-action/xbomber
	!sys-devel/cons"
PDEPEND="
	!minimal? (
		sci-biology/aaindex
		sci-biology/cutg
		sci-biology/primer3
		sci-biology/prints
		sci-biology/prosite
		sci-biology/rebase
	)"

S="${WORKDIR}/${P^^}"

PATCHES=(
	"${FILESDIR}"/${P}_fix-build-system.patch
	"${FILESDIR}"/${P}_FORTIFY_SOURCE-fix.patch
	"${FILESDIR}"/${P}_plplot-declarations.patch
	"${FILESDIR}"/${P}_qa-implicit-declarations.patch
)

src_install() {
	emboss-r2_src_install

	readme.gentoo_create_doc

	# Install env file for setting libplplot and acd files path.
	cat > 22emboss <<- EOF || die
		# ACD files location
		EMBOSS_ACDROOT="${EPREFIX}/usr/share/EMBOSS/acd"
		EMBOSS_DATA="${EPREFIX}/usr/share/EMBOSS/data"
	EOF
	doenvd 22emboss

	# Remove useless dummy files
	find "${ED%/}"/usr/share/EMBOSS -name dummyfile -delete || die "Failed to remove dummy files"

	# Move the provided codon files to a different directory. This will avoid
	# user confusion and file collisions on case-insensitive file systems (see
	# bug #115446). This change is documented in "README.gentoo".
	mv "${ED%/}"/usr/share/EMBOSS/data/CODONS{,.orig} \
		|| die "Failed to move CODON directory"
}

pkg_postinst() {
	readme.gentoo_print_elog
}
