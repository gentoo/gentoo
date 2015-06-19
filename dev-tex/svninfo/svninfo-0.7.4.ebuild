# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tex/svninfo/svninfo-0.7.4.ebuild,v 1.16 2013/04/25 21:29:49 ago Exp $

inherit latex-package eutils

LICENSE="LPPL-1.2"
DESCRIPTION="A LaTeX module to access SVN version info"
HOMEPAGE="http://www.brucker.ch/projects/svninfo/index.en.html"
SRC_URI="http://www.brucker.ch/projects/svninfo/download/${P}.tar.gz"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE=""

DOCS="README"

TEXMF=/usr/share/texmf-site

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${PN}-0.5-latex-compile.patch"
}

src_compile() {
	export VARTEXFONTS="${T}/fonts"
	emake -j1 || die "compilation failed"
}
