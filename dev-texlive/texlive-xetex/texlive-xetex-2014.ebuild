# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-texlive/texlive-xetex/texlive-xetex-2014.ebuild,v 1.1 2014/11/03 07:01:11 aballier Exp $

EAPI="5"

TEXLIVE_MODULE_CONTENTS="arabxetex bidi-atbegshi bidicontour bidipagegrid bidishadowtext bidipresentation euenc fixlatvian fontbook fontwrap mathspec philokalia polyglossia ptext realscripts ucharclasses unisugar xecjk xecolor xecyr xeindex xepersian xesearch xetex xetex-def xetex-itrans xetex-pstricks xetex-tibetan xetexconfig xetexfontinfo xetexko xevlna xltxtra xunicode collection-xetex
"
TEXLIVE_MODULE_DOC_CONTENTS="arabxetex.doc bidi-atbegshi.doc bidicontour.doc bidipagegrid.doc bidishadowtext.doc bidipresentation.doc euenc.doc fixlatvian.doc fontbook.doc fontwrap.doc mathspec.doc philokalia.doc polyglossia.doc ptext.doc realscripts.doc ucharclasses.doc unisugar.doc xecjk.doc xecolor.doc xecyr.doc xeindex.doc xepersian.doc xesearch.doc xetex.doc xetex-itrans.doc xetex-pstricks.doc xetex-tibetan.doc xetexfontinfo.doc xetexko.doc xevlna.doc xltxtra.doc xunicode.doc "
TEXLIVE_MODULE_SRC_CONTENTS="arabxetex.source euenc.source fixlatvian.source fontbook.source philokalia.source polyglossia.source realscripts.source xecjk.source xepersian.source xltxtra.source "
inherit font texlive-module
DESCRIPTION="TeXLive XeTeX and packages"

LICENSE=" Apache-2.0 GPL-1 GPL-2 LPPL-1.2 LPPL-1.3 OFL public-domain TeX-other-free "
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~mips ~ppc ~ppc64 ~s390 ~sh ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
DEPEND=">=dev-texlive/texlive-basic-2014
!=app-text/texlive-core-2007*
>=dev-texlive/texlive-latexextra-2010
>=app-text/texlive-core-2010[xetex]
>=dev-texlive/texlive-genericrecommended-2010
>=dev-texlive/texlive-mathextra-2012
!<dev-texlive/texlive-mathextra-2012
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
