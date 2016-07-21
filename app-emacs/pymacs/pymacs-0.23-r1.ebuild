# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"
PYTHON_DEPEND="2"

inherit distutils elisp

MY_P=Pymacs-${PV}
DESCRIPTION="A tool that allows both-side communication beetween Python and Emacs Lisp"
HOMEPAGE="http://pymacs.progiciels-bpi.ca/"
SRC_URI="http://pymacs.progiciels-bpi.ca/archives/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm hppa ia64 ppc ppc64 s390 sh x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="doc"

# additional doc? dependencies for multirow.sty and aeguill.sty (bug 247703)
DEPEND="
	doc? ( dev-python/docutils
		virtual/latex-base
		dev-texlive/texlive-latexextra
		dev-texlive/texlive-langfrench )"
RDEPEND=""

SITEFILE=50${PN}-gentoo.el

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	python_set_active_version 2
}

src_compile() {
	emake || die "emake failed"
	elisp-compile pymacs.el || die "elisp-compile failed"
	if use doc; then
		VARTEXFONTS="${T}"/fonts \
			emake pymacs.pdf || die "emake pymacs.pdf failed"
	fi
}

src_install() {
	elisp_src_install
	distutils_src_install
	dodoc THANKS pymacs.rst
	if use doc; then
		insinto /usr/share/doc/${PF}
		doins pymacs.pdf
	fi
}
