# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools emboss-r3 readme.gentoo-r1

DESCRIPTION="The European Molecular Biology Open Software Suite - A sequence analysis package"
SRC_URI="
	ftp://emboss.open-bio.org/pub/${PN^^}/${P^^}.tar.gz
	https://dev.gentoo.org/~soap/distfiles/${P}-patches-r1.tar.xz"
S="${WORKDIR}/${P^^}"

LICENSE+=" Apache-2.0 GPL-3+ CC-BY-3.0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="minimal"

RDEPEND="
	!dev-build/cons
	!games-action/xbomber
"
PDEPEND="
	!minimal? (
		sci-biology/aaindex
		sci-biology/cutg
		sci-biology/primer3
		sci-biology/prints
		sci-biology/prosite
		sci-biology/rebase
	)"

PATCHES=(
	"${WORKDIR}"/patches/${P}-fix-build-system.patch
	"${WORKDIR}"/patches/${P}-FORTIFY_SOURCE-fix.patch
	"${WORKDIR}"/patches/${P}-plplot-declarations.patch
	"${WORKDIR}"/patches/${P}-qa-implicit-declarations.patch
	"${WORKDIR}"/patches/${P}-C99-bool.patch
	"${WORKDIR}"/patches/${P}-Wimplicit-function-declaration.patch
)

src_prepare() {
	default
	eautoreconf
}

src_install() {
	emboss-r3_src_install

	readme.gentoo_create_doc

	# Install env file for setting libplplot and acd files path.
	newenvd - 22emboss <<- EOF
		# ACD files location
		EMBOSS_ACDROOT="${EPREFIX}/usr/share/EMBOSS/acd"
		EMBOSS_DATA="${EPREFIX}/usr/share/EMBOSS/data"
	EOF

	# Remove useless dummy files
	find "${ED}"/usr/share/EMBOSS -name dummyfile -delete \
		|| die "Failed to remove dummy files"

	# Move the provided codon files to a different directory. This will avoid
	# user confusion and file collisions on case-insensitive file systems (see
	# bug #115446). This change is documented in "README.gentoo".
	mv "${ED}"/usr/share/EMBOSS/data/CODONS{,.orig} \
		|| die "Failed to move CODON directory"
}

pkg_postinst() {
	readme.gentoo_print_elog
}
