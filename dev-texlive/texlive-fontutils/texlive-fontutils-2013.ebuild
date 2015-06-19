# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-texlive/texlive-fontutils/texlive-fontutils-2013.ebuild,v 1.1 2013/06/28 16:12:05 aballier Exp $

EAPI="5"

TEXLIVE_MODULE_CONTENTS="accfonts afm2pl dosepsbin epstopdf fontware lcdftypetools ps2pkm pstools psutils dvipsconfig fontinst fontools mf2pt1 t1utils collection-fontutils
"
TEXLIVE_MODULE_DOC_CONTENTS="accfonts.doc afm2pl.doc dosepsbin.doc epstopdf.doc fontware.doc lcdftypetools.doc pstools.doc psutils.doc fontinst.doc fontools.doc mf2pt1.doc t1utils.doc "
TEXLIVE_MODULE_SRC_CONTENTS="dosepsbin.source fontinst.source "
inherit  texlive-module
DESCRIPTION="TeXLive Graphics and font utilities"

LICENSE=" Artistic GPL-1 GPL-2 LPPL-1.3 public-domain TeX-other-free "
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
DEPEND=">=dev-texlive/texlive-basic-2013
!dev-texlive/texlive-psutils
!<dev-texlive/texlive-fontsextra-2009
!<app-text/texlive-core-2013
"
RDEPEND="${DEPEND} "
TEXLIVE_MODULE_BINSCRIPTS="
	texmf-dist/scripts/accfonts/mkt1font
	texmf-dist/scripts/accfonts/vpl2ovp
	texmf-dist/scripts/accfonts/vpl2vpl
	texmf-dist/scripts/epstopdf/epstopdf.pl
	texmf-dist/scripts/fontools/afm2afm
	texmf-dist/scripts/fontools/autoinst
	texmf-dist/scripts/fontools/ot2kpx
	texmf-dist/scripts/mf2pt1/mf2pt1.pl
	texmf-dist/scripts/dosepsbin/dosepsbin.pl
	texmf-dist/scripts/texlive/fontinst.sh
	texmf-dist/scripts/texlive/ps2frag.sh
	texmf-dist/scripts/texlive/pslatex.sh
"
TEXLIVE_MODULE_BINLINKS="
	epstopdf:repstopdf
"
