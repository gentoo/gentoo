# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

TEXLIVE_MODULE_CONTENTS="context jmn context-account context-algorithmic context-bnf context-chromato context-construction-plan context-cyrillicnumbers context-degrade context-filter context-fixme context-french context-fullpage context-games context-gantt context-gnuplot context-letter context-lettrine context-lilypond context-mathsets context-notes-zh-cn context-rst context-ruby context-simplefonts context-simpleslides context-transliterator context-typearea context-typescripts context-vim collection-context
"
TEXLIVE_MODULE_DOC_CONTENTS="context.doc context-account.doc context-bnf.doc context-chromato.doc context-construction-plan.doc context-cyrillicnumbers.doc context-degrade.doc context-filter.doc context-french.doc context-fullpage.doc context-games.doc context-gantt.doc context-gnuplot.doc context-letter.doc context-lettrine.doc context-lilypond.doc context-mathsets.doc context-notes-zh-cn.doc context-rst.doc context-ruby.doc context-simplefonts.doc context-simpleslides.doc context-transliterator.doc context-typearea.doc context-typescripts.doc context-vim.doc "
TEXLIVE_MODULE_SRC_CONTENTS=""
inherit  texlive-module
DESCRIPTION="TeXLive ConTeXt and packages"

LICENSE=" BSD GPL-1 GPL-2 public-domain TeX-other-free "
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~mips ppc ~ppc64 ~s390 ~sh x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
DEPEND=">=dev-texlive/texlive-basic-2014
>=dev-texlive/texlive-latex-2010
!<dev-texlive/texlive-latex-2010
>=app-text/texlive-core-2010[xetex]
>=dev-texlive/texlive-metapost-2010
"
RDEPEND="${DEPEND} dev-lang/ruby
"
PATCHES=( "${FILESDIR}/luacnfspec2013.patch" )

TL_CONTEXT_UNIX_STUBS="contextjit mtxrunjit mtxrun texexec context metatex luatools mtxworks texmfstart"

TEXLIVE_MODULE_BINSCRIPTS=""

for i in ${TL_CONTEXT_UNIX_STUBS} ; do
TEXLIVE_MODULE_BINSCRIPTS="${TEXLIVE_MODULE_BINSCRIPTS} texmf-dist/scripts/context/stubs/unix/$i"
done

# This small hack is needed in order to have a sane upgrade path:
# the new TeX Live 2009 metapost produces this file but it is not recorded in
# any package; when running fmtutil (like texmf-update does) this file will be
# created and cause collisions.

pkg_setup() {
	if [ -f "${ROOT}/var/lib/texmf/web2c/metapost/metafun.log" ]; then
		einfo "Removing ${ROOT}/var/lib/texmf/web2c/metapost/metafun.log"
		rm -f "${ROOT}/var/lib/texmf/web2c/metapost/metafun.log"
	fi
}

# These comes without +x bit set...
src_prepare() {
	# No need to install these .exe
	rm -rf texmf-dist/scripts/context/stubs/{mswin,win64} || die

	texlive-module_src_prepare
}

TL_MODULE_INFORMATION="For using ConTeXt mkII simply use 'texexec' to generate
your documents.
If you plan to use mkIV and its 'context' command to generate your documents,
you have to run 'luatools --generate' as normal user before first use.

More information and advanced options on:
http://wiki.contextgarden.net/TeX_Live_2011"
