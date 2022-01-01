# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

TEXLIVE_MODULE_CONTENTS="babel-catalan babel-galician babel-spanish es-tex-faq hyphen-catalan hyphen-galician hyphen-spanish l2tabu-spanish latex2e-help-texinfo-spanish latexcheat-esmx lshort-spanish texlive-es collection-langspanish
"
TEXLIVE_MODULE_DOC_CONTENTS="babel-catalan.doc babel-galician.doc babel-spanish.doc es-tex-faq.doc hyphen-spanish.doc l2tabu-spanish.doc latex2e-help-texinfo-spanish.doc latexcheat-esmx.doc lshort-spanish.doc texlive-es.doc "
TEXLIVE_MODULE_SRC_CONTENTS="babel-catalan.source babel-galician.source babel-spanish.source hyphen-galician.source hyphen-spanish.source "
inherit  texlive-module
DESCRIPTION="TeXLive Spanish"

LICENSE=" GPL-2 LPPL-1.3 MIT public-domain TeX-other-free "
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
DEPEND=">=dev-texlive/texlive-basic-2021"

RDEPEND="${DEPEND} "
