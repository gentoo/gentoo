# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

TEXLIVE_MODULE_CONTENTS="arabxetex euenc fixlatvian fontbook fontwrap mathspec philokalia polyglossia realscripts unisugar xecjk xecolor xecyr xeindex xepersian xesearch xetex xetex-def xetex-itrans xetex-pstricks xetexconfig xetexfontinfo xltxtra xunicode collection-xetex
"
TEXLIVE_MODULE_DOC_CONTENTS="arabxetex.doc euenc.doc fixlatvian.doc fontbook.doc fontwrap.doc mathspec.doc philokalia.doc polyglossia.doc realscripts.doc unisugar.doc xecjk.doc xecolor.doc xecyr.doc xeindex.doc xepersian.doc xesearch.doc xetex.doc xetex-itrans.doc xetex-pstricks.doc xetexfontinfo.doc xltxtra.doc xunicode.doc "
TEXLIVE_MODULE_SRC_CONTENTS="arabxetex.source euenc.source fixlatvian.source fontbook.source philokalia.source polyglossia.source realscripts.source xecjk.source xepersian.source xltxtra.source "
inherit font texlive-module
DESCRIPTION="TeXLive XeTeX packages"

LICENSE="GPL-2 Apache-2.0 GPL-1 LPPL-1.3 OFL public-domain TeX-other-free"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
DEPEND=">=dev-texlive/texlive-basic-2012
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
