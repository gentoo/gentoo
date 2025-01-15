# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

TEXLIVE_MODULE_CONTENTS="
	collection-xetex.r71515
	arabxetex.r38299
	bidi-atbegshi.r62009
	bidicontour.r34631
	bidipagegrid.r34632
	bidipresentation.r35267
	bidishadowtext.r34633
	businesscard-qrcode.r61719
	cqubeamer.r54512
	fixlatvian.r21631
	font-change-xetex.r40404
	fontbook.r23608
	fontwrap.r15878
	interchar.r36312
	na-position.r55559
	philokalia.r45356
	ptext.r30171
	realscripts.r56594
	simple-resume-cv.r43057
	simple-thesis-dissertation.r43058
	tetragonos.r49732
	ucharclasses.r64782
	unicode-bidi.r42482
	unimath-plain-xetex.r72498
	unisugar.r22357
	xebaposter.r63513
	xechangebar.r54080
	xecolor.r29660
	xecyr.r54308
	xeindex.r35756
	xelatex-dev.r71363
	xesearch.r51908
	xespotcolor.r58212
	xetex.r71991
	xetex-itrans.r55475
	xetex-pstricks.r17055
	xetex-tibetan.r28847
	xetexconfig.r45845
	xetexfontinfo.r15878
	xetexko.r70315
	xevlna.r43864
	zbmath-review-template.r59693
"
TEXLIVE_MODULE_DOC_CONTENTS="
	arabxetex.doc.r38299
	bidi-atbegshi.doc.r62009
	bidicontour.doc.r34631
	bidipagegrid.doc.r34632
	bidipresentation.doc.r35267
	bidishadowtext.doc.r34633
	businesscard-qrcode.doc.r61719
	cqubeamer.doc.r54512
	fixlatvian.doc.r21631
	font-change-xetex.doc.r40404
	fontbook.doc.r23608
	fontwrap.doc.r15878
	interchar.doc.r36312
	na-position.doc.r55559
	philokalia.doc.r45356
	ptext.doc.r30171
	realscripts.doc.r56594
	simple-resume-cv.doc.r43057
	simple-thesis-dissertation.doc.r43058
	tetragonos.doc.r49732
	ucharclasses.doc.r64782
	unicode-bidi.doc.r42482
	unimath-plain-xetex.doc.r72498
	unisugar.doc.r22357
	xebaposter.doc.r63513
	xechangebar.doc.r54080
	xecolor.doc.r29660
	xecyr.doc.r54308
	xeindex.doc.r35756
	xesearch.doc.r51908
	xespotcolor.doc.r58212
	xetex.doc.r71991
	xetex-itrans.doc.r55475
	xetex-pstricks.doc.r17055
	xetex-tibetan.doc.r28847
	xetexfontinfo.doc.r15878
	xetexko.doc.r70315
	xevlna.doc.r43864
	zbmath-review-template.doc.r59693
"
TEXLIVE_MODULE_SRC_CONTENTS="
	arabxetex.source.r38299
	fixlatvian.source.r21631
	fontbook.source.r23608
	philokalia.source.r45356
	realscripts.source.r56594
	xespotcolor.source.r58212
"

inherit font texlive-module

DESCRIPTION="TeXLive XeTeX and packages"

LICENSE="Apache-2.0 CC-BY-4.0 CC-BY-SA-4.0 GPL-1+ GPL-3 LGPL-2+ LPPL-1.2 LPPL-1.3 LPPL-1.3c MIT TeX-other-free public-domain"
SLOT="0"
KEYWORDS="amd64"
COMMON_DEPEND="
	>=app-text/texlive-core-2024[xetex]
	>=dev-texlive/texlive-basic-2024
	>=dev-texlive/texlive-latex-2024
"
RDEPEND="
	${COMMON_DEPEND}
"
DEPEND="
	${COMMON_DEPEND}
	!!<dev-texlive/texlive-latexextra-2023
"

TEXLIVE_MODULE_BINSCRIPTS="
	texmf-dist/scripts/texlive-extra/xelatex-unsafe.sh
	texmf-dist/scripts/texlive-extra/xetex-unsafe.sh
"

FONT_CONF=( "${FILESDIR}"/09-texlive.conf )

src_install() {
	texlive-module_src_install
	font_fontconfig
}

pkg_postinst() {
	texlive-module_pkg_postinst
	font_pkg_postinst
}

pkg_postrm() {
	texlive-module_pkg_postrm
	font_pkg_postrm
}
