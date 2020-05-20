# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

TEXLIVE_MODULE_CONTENTS="arabxetex awesomebox bidi-atbegshi bidicontour bidipagegrid bidishadowtext bidipresentation businesscard-qrcode cqubeamer fixlatvian font-change-xetex fontbook fontwrap interchar na-position philokalia ptext quran quran-de realscripts simple-resume-cv simple-thesis-dissertation tetragonos ucharclasses unicode-bidi unisugar xebaposter xechangebar xecjk xecolor xecyr xeindex xelatex-dev xesearch xespotcolor xetex xetex-itrans xetex-pstricks xetex-tibetan xetexconfig xetexfontinfo xetexko xevlna collection-xetex
"
TEXLIVE_MODULE_DOC_CONTENTS="arabxetex.doc awesomebox.doc bidi-atbegshi.doc bidicontour.doc bidipagegrid.doc bidishadowtext.doc bidipresentation.doc businesscard-qrcode.doc cqubeamer.doc fixlatvian.doc font-change-xetex.doc fontbook.doc fontwrap.doc interchar.doc na-position.doc philokalia.doc ptext.doc quran.doc quran-de.doc realscripts.doc simple-resume-cv.doc simple-thesis-dissertation.doc tetragonos.doc ucharclasses.doc unicode-bidi.doc unisugar.doc xebaposter.doc xechangebar.doc xecjk.doc xecolor.doc xecyr.doc xeindex.doc xesearch.doc xespotcolor.doc xetex.doc xetex-itrans.doc xetex-pstricks.doc xetex-tibetan.doc xetexfontinfo.doc xetexko.doc xevlna.doc "
TEXLIVE_MODULE_SRC_CONTENTS="arabxetex.source fixlatvian.source fontbook.source philokalia.source realscripts.source xecjk.source xespotcolor.source "
inherit font texlive-module
DESCRIPTION="TeXLive XeTeX and packages"

LICENSE=" Apache-2.0 GPL-1 GPL-2 LGPL-2 LPPL-1.2 LPPL-1.3 LPPL-1.3c MIT CC-BY-4.0 "
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
DEPEND=">=dev-texlive/texlive-basic-2020
>=dev-texlive/texlive-latexextra-2010
>=app-text/texlive-core-2010[xetex]
dev-texlive/texlive-mathscience
dev-texlive/texlive-luatex
"
RDEPEND="${DEPEND} "
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
