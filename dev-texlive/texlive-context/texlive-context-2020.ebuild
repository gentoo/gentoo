# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

TEXLIVE_MODULE_CONTENTS="context jmn context-notes-zh-cn npp-for-context context-account context-algorithmic context-animation context-annotation context-bnf context-chromato context-cmscbf context-cmttbf context-construction-plan context-cyrillicnumbers context-degrade context-fancybreak context-filter context-french context-fullpage context-gantt context-gnuplot context-handlecsv context-inifile context-layout context-letter context-lettrine context-mathsets context-rst context-ruby context-simplefonts context-simpleslides context-title context-transliterator context-typearea context-typescripts context-vim context-visualcounter collection-context
"
TEXLIVE_MODULE_DOC_CONTENTS="context.doc context-notes-zh-cn.doc npp-for-context.doc context-account.doc context-algorithmic.doc context-animation.doc context-annotation.doc context-bnf.doc context-chromato.doc context-cmscbf.doc context-cmttbf.doc context-construction-plan.doc context-cyrillicnumbers.doc context-degrade.doc context-fancybreak.doc context-filter.doc context-french.doc context-fullpage.doc context-gantt.doc context-gnuplot.doc context-handlecsv.doc context-inifile.doc context-layout.doc context-letter.doc context-lettrine.doc context-mathsets.doc context-rst.doc context-ruby.doc context-simplefonts.doc context-simpleslides.doc context-title.doc context-transliterator.doc context-typearea.doc context-typescripts.doc context-vim.doc context-visualcounter.doc "
TEXLIVE_MODULE_SRC_CONTENTS="context-visualcounter.source "
inherit  texlive-module
DESCRIPTION="TeXLive ConTeXt and packages"

LICENSE=" BSD BSD-2 GPL-1 GPL-2 GPL-3 public-domain TeX-other-free "
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~mips ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
DEPEND=">=dev-texlive/texlive-basic-2020
>=dev-texlive/texlive-latex-2010
>=app-text/texlive-core-2010[xetex]
>=dev-texlive/texlive-metapost-2010
"
RDEPEND="${DEPEND} dev-lang/ruby
"

TL_CONTEXT_UNIX_STUBS="contextjit mtxrunjit mtxrun texexec context luatools texmfstart"

TEXLIVE_MODULE_BINSCRIPTS=""

for i in ${TL_CONTEXT_UNIX_STUBS} ; do
TEXLIVE_MODULE_BINSCRIPTS="${TEXLIVE_MODULE_BINSCRIPTS} texmf-dist/scripts/context/stubs/unix/${i}"
done

# This small hack is needed in order to have a sane upgrade path:
# the new TeX Live 2009 metapost produces this file but it is not recorded in
# any package; when running fmtutil (like texmf-update does) this file will be
# created and cause collisions.

pkg_setup() {
	if [ -f "${ROOT}/var/lib/texmf/web2c/metapost/metafun.log" ]; then
		einfo "Removing ${ROOT}/var/lib/texmf/web2c/metapost/metafun.log"
		rm -f "${ROOT}/var/lib/texmf/web2c/metapost/metafun.log" || die
	fi
}

# These comes without +x bit set...
src_prepare() {
	# No need to install these .exe
	rm -rf texmf-dist/scripts/context/stubs/{mswin,win64} || die

	default
}

TL_MODULE_INFORMATION="For using ConTeXt mkII simply use 'texexec' to generate
your documents.
If you plan to use mkIV and its 'context' command to generate your documents,
you have to run 'mtxrun --generate' as normal user before first use.

More information and advanced options on:
http://wiki.contextgarden.net/TeX_Live_2011"
