# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-texlive/texlive-documentation-chinese/texlive-documentation-chinese-2012.ebuild,v 1.12 2013/04/25 21:26:23 ago Exp $

EAPI="4"

TEXLIVE_MODULE_CONTENTS="asymptote-faq-zh-cn asymptote-by-example-zh-cn asymptote-manual-zh-cn ctex-faq latex-notes-zh-cn lshort-chinese texlive-zh-cn collection-documentation-chinese
"
TEXLIVE_MODULE_DOC_CONTENTS="asymptote-faq-zh-cn.doc asymptote-by-example-zh-cn.doc asymptote-manual-zh-cn.doc ctex-faq.doc latex-notes-zh-cn.doc lshort-chinese.doc texlive-zh-cn.doc "
TEXLIVE_MODULE_SRC_CONTENTS=""
inherit  texlive-module
DESCRIPTION="TeXLive Chinese documentation"

LICENSE="GPL-2 FDL-1.1 GPL-1 LGPL-2 LPPL-1.3 "
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
DEPEND=">=dev-texlive/texlive-documentation-base-2012
"
RDEPEND="${DEPEND} "
