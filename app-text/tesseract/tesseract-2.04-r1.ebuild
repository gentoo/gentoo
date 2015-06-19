# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/tesseract/tesseract-2.04-r1.ebuild,v 1.8 2012/06/04 11:40:10 jlec Exp $

EAPI="2"

inherit eutils

DESCRIPTION="An OCR Engine that was developed at HP and now at Google"
HOMEPAGE="http://code.google.com/p/tesseract-ocr/"
SRC_URI="http://tesseract-ocr.googlecode.com/files/${P}.tar.gz
	http://tesseract-ocr.googlecode.com/files/${PN}-2.00.eng.tar.gz
	linguas_de? (
		http://tesseract-ocr.googlecode.com/files/${PN}-2.00.deu.tar.gz
		http://tesseract-ocr.googlecode.com/files/${PN}-2.01.deu-f.tar.gz
	)
	linguas_eu? ( http://tesseract-ocr.googlecode.com/files/${PN}-2.04.eus.tar.gz )
	linguas_es? ( http://tesseract-ocr.googlecode.com/files/${PN}-2.00.spa.tar.gz )
	linguas_fr? ( http://tesseract-ocr.googlecode.com/files/${PN}-2.00.fra.tar.gz )
	linguas_it? ( http://tesseract-ocr.googlecode.com/files/${PN}-2.00.ita.tar.gz )
	linguas_nl? ( http://tesseract-ocr.googlecode.com/files/${PN}-2.00.nld.tar.gz )
	linguas_pt_BR? ( http://tesseract-ocr.googlecode.com/files/${PN}-2.01.por.tar.gz )
	linguas_vi? ( http://tesseract-ocr.googlecode.com/files/${PN}-2.01.vie.tar.gz )"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ~mips ppc ppc64 sparc x86"
IUSE="examples tiff linguas_de linguas_eu linguas_es linguas_fr linguas_it linguas_nl linguas_pt_BR linguas_vi"

DEPEND="tiff? ( media-libs/tiff )"
RDEPEND="${DEPEND}"

# NOTES:
# english language files are always installed because they are used by default
#   that is a tesseract bug and if possible this workaround should be avoided
#   see bug 287373
# deu-f corresponds to an old german graphic style named fraktur
#   that's the same language (german, de)
# stuff in directory java/ seems useless...
# in testing/, there is a way to test accuracy, not usable for src_test()
# app-ocr/ would be a better category

src_prepare() {
	# move language files to have them installed
	mv "${WORKDIR}"/tessdata/* tessdata/ || die "move language files failed"

	# remove obsolete makefile, install target only in uppercase Makefile
	rm "${S}/java/makefile" || die "remove obsolete java makefile failed"

	# fix gcc-4.4 compilation, bug 269320
	# fix gcc-4.7 compilation, bug 413937
	epatch \
		"${FILESDIR}"/${P}-gcc44.patch \
		"${FILESDIR}"/${P}-gcc47.patch
}

src_configure() {
	econf $(use_with tiff libtiff) \
		--disable-dependency-tracking
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	dodoc AUTHORS ChangeLog NEWS README ReleaseNotes || die "dodoc failed"

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins eurotext.tif phototest.tif || die "doins failed"
	fi
}
