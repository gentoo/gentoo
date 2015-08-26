# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=1

inherit eutils

DESCRIPTION="The European Molecular Biology Open Software Suite - A sequence analysis package"
HOMEPAGE="http://emboss.sourceforge.net/"
SRC_URI="ftp://${PN}.open-bio.org/pub/EMBOSS/old/${PV}/EMBOSS-${PV}.tar.gz"
LICENSE="GPL-2 LGPL-2"

SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="X png minimal"

DEPEND="
	X? ( x11-libs/libXt )
	png? (
		sys-libs/zlib
		media-libs/libpng
		media-libs/gd
		)
	!minimal? (
		sci-biology/primer3
		sci-biology/clustalw
		)"

RDEPEND="${DEPEND}
	!sys-devel/cons"

PDEPEND="
	!minimal? (
		sci-biology/aaindex
		sci-biology/cutg
		sci-biology/prints
		sci-biology/prosite
		sci-biology/rebase
		sci-biology/transfac
	)"

S="${WORKDIR}/EMBOSS-${PV}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PN}-5.0.0-as-needed.patch

	local link_string="$(pkg-config --libs x11)"
	if use png; then
		link_string="${link_string} -lgd $(pkg-config --libs libpng)"
	fi
	sed -e "s:PATCH_PLPLOT:${link_string}:" -i plplot/Makefile.in \
		|| die "Failed to patch ajax Makefile"
}

src_compile() {
	local myconf
	myconf="--includedir=${D}/usr/include/emboss"
	use X || myconf="${EXTRA_CONF} --without-x"
	use png || myconf="${EXTRA_CONF} --without-pngdriver"

	econf ${myconf}
	# Do not install the JEMBOSS component (the --without-java configure option
	# does not work). JEMBOSS will eventually be available as a separate package.
	sed -i -e "s/SUBDIRS = plplot ajax nucleus emboss test doc jemboss/SUBDIRS = plplot ajax nucleus emboss test doc/" \
			Makefile || die
	emake || die
}

src_install() {
	einstall || die "Failed to install program files."

	dodoc AUTHORS ChangeLog FAQ NEWS README THANKS \
			|| die "Failed to install documentation."
	newdoc "${FILESDIR}"/${PN}-README.Gentoo-1 README.Gentoo \
			|| die "Failed to install Gentoo readme file."

	# Install env file for setting libplplot and acd files path.
	cat <<- EOF > 22emboss
		# plplot libs dir
		PLPLOT_LIB="/usr/share/EMBOSS/"
		# ACD files location
		EMBOSS_ACDROOT="/usr/share/EMBOSS/acd"
	EOF
	doenvd 22emboss || die "Failed to install environment file."

	# Symlink preinstalled docs to "/usr/share/doc".
	dosym /usr/share/EMBOSS/doc/manuals /usr/share/doc/${PF}/manuals || die
	dosym /usr/share/EMBOSS/doc/programs /usr/share/doc/${PF}/programs || die
	dosym /usr/share/EMBOSS/doc/tutorials /usr/share/doc/${PF}/tutorials || die
	dosym /usr/share/EMBOSS/doc/html /usr/share/doc/${PF}/html || die

	# Clashes #330507
	mv "${D}"/usr/bin/{digest,pepdigest} || die

	# Remove useless dummy files from the image.
	find emboss/data -name dummyfile -delete || die "Failed to remove dummy files."

	# Move the provided codon files to a different directory. This will avoid
	# user confusion and file collisions on case-insensitive file systems (see
	# bug #115446). This change is documented in "README.Gentoo".
	mv "${D}"/usr/share/EMBOSS/data/CODONS{,.orig} || \
			die "Failed to move CODON directory."

	# Move the provided restriction enzyme prototypes file to a different name.
	# This avoids file collisions with versions of rebase that install their
	# own enzyme prototypes file (see bug #118832).
	mv "${D}"/usr/share/EMBOSS/data/embossre.equ{,.orig} || \
			die "Failed to move enzyme equivalence file."
}
