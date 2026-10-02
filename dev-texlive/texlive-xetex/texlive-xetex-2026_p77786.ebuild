# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

TEXLIVE_MODULE_CONTENTS="
	collection-xetex.r78834
	arabxetex.r79618
	bidi-atbegshi.r62009
	bidicontour.r77682
	bidipagegrid.r77682
	bidipresentation.r35267
	bidishadowtext.r77682
	businesscard-qrcode.r76924
	cqubeamer.r54512
	ctex.r79708
	fixlatvian.r21631
	font-change-xetex.r40404
	fontbook.r23608
	fontwrap.r15878
	interchar.r77682
	na-position.r55559
	philokalia.r45356
	ptext.r77682
	shtthesis.r62441
	simple-resume-cv.r43057
	simple-thesis-dissertation.r43058
	tetragonos.r49732
	ucharclasses.r77682
	unicode-bidi.r77682
	unimath-plain-xetex.r72498
	unisugar.r22357
	xebaposter.r75290
	xechangebar.r77682
	xecjk.r79711
	xecolor.r77682
	xecyr.r77682
	xeindex.r77682
	xelatex-dev.r71363
	xesearch.r77682
	xespotcolor.r77682
	xetex.r77830
	xetex-devanagari.r34296
	xetex-itrans.r55475
	xetex-pstricks.r17055
	xetex-tibetan.r28847
	xetexconfig.r45845
	xetexfontinfo.r15878
	xetexko.r77682
	xevlna.r77682
	zbmath-review-template.r59693
"
TEXLIVE_MODULE_SRC_CONTENTS="
	arabxetex.doc.r79618
	bidi-atbegshi.doc.r62009
	bidicontour.doc.r77682
	bidipagegrid.doc.r77682
	bidipresentation.doc.r35267
	bidishadowtext.doc.r77682
	businesscard-qrcode.doc.r76924
	cqubeamer.doc.r54512
	ctex.doc.r79708
	ctex-faq.doc.r15878
	fixlatvian.doc.r21631
	font-change-xetex.doc.r40404
	fontbook.doc.r23608
	fontwrap.doc.r15878
	interchar.doc.r77682
	na-position.doc.r55559
	philokalia.doc.r45356
	ptext.doc.r77682
	shtthesis.doc.r62441
	simple-resume-cv.doc.r43057
	simple-thesis-dissertation.doc.r43058
	tetragonos.doc.r49732
	ucharclasses.doc.r77682
	unicode-bidi.doc.r77682
	unimath-plain-xetex.doc.r72498
	unisugar.doc.r22357
	xebaposter.doc.r75290
	xechangebar.doc.r77682
	xecjk.doc.r79711
	xecolor.doc.r77682
	xecyr.doc.r77682
	xeindex.doc.r77682
	xesearch.doc.r77682
	xespotcolor.doc.r77682
	xetex.doc.r77830
	xetex-devanagari.doc.r34296
	xetex-itrans.doc.r55475
	xetex-pstricks.doc.r17055
	xetex-tibetan.doc.r28847
	xetexfontinfo.doc.r15878
	xetexko.doc.r77682
	xetexref.doc.r73885
	xevlna.doc.r77682
	zbmath-review-template.doc.r59693
"
TEXLIVE_MODULE_DOC_CONTENTS="
	arabxetex.source.r79618
	ctex.source.r79708
	fixlatvian.source.r21631
	fontbook.source.r23608
	philokalia.source.r45356
	xecjk.source.r79711
	xespotcolor.source.r77682
"

inherit font texlive-module

DESCRIPTION="TeXLive XeTeX and packages"

LICENSE="Apache-2.0 CC-BY-4.0 CC-BY-SA-4.0 FDL-1.1+ GPL-1+ GPL-3 LGPL-2+ LPPL-1.2 LPPL-1.3 LPPL-1.3c MIT TeX-other-free public-domain"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
COMMON_DEPEND="
	>=app-text/texlive-core-2026[xetex]
	>=dev-texlive/texlive-basic-2026
	>=dev-texlive/texlive-latex-2026
"
RDEPEND="
	${COMMON_DEPEND}
	!<dev-texlive/texlive-publishers-2026
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
