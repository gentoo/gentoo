# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="A Flexible Indexing System"
HOMEPAGE="http://www.xindy.org/ https://github.com/jschrod/xindy.ctan"
SRC_URI="http://www.xindy.org/${P}.tar.gz"

# The latest development is now on the TeXlive SVN.
# The author jschrod backports it from time to time to his github repo.

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ia64 ppc x86"
IUSE="doc"

RDEPEND="virtual/latex-base
	dev-texlive/texlive-fontsrecommended
	>=dev-lisp/clisp-2.44.1-r1
	dev-texlive/texlive-langcyrillic"
DEPEND="${RDEPEND}
	dev-lang/perl
	sys-devel/flex"

PATCHES=("${FILESDIR}"/${P}-configure.patch
	"${FILESDIR}"/${P}-locale.patch
	"${FILESDIR}"/${P}-nogrep.patch
	"${FILESDIR}"/${P}-perl5.26.patch)
DOCS=(AUTHORS ChangeLog.Gour NEWS README)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf $(use_enable doc docs)
}

src_compile() {
	VARTEXFONTS="${T}/fonts" emake
}
