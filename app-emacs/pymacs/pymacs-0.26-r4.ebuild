# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..11} )

inherit elisp distutils-r1

DESCRIPTION="A tool that allows both-side communication between Python and Emacs Lisp"
HOMEPAGE="https://www.emacswiki.org/emacs/PyMacs
	https://github.com/dgentry/Pymacs/"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/dgentry/${PN^}.git"
else
	SRC_URI="https://github.com/dgentry/${PN^}/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}"/${P^}
	KEYWORDS="amd64 arm ~hppa ~ia64 ppc ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos"
fi

LICENSE="GPL-2+"
SLOT="0"
IUSE="doc"

BDEPEND="
	doc? (
		>=dev-python/docutils-0.7
		virtual/latex-base
	)
"

DOCS=( ${PN}.rst )
SITEFILE="50${PN}-gentoo.el"

python_configure() {
	emake PYSETUP=: PYTHON=${EPYTHON} prepare
}

src_prepare() {
	distutils-r1_src_prepare
	elisp_src_prepare
}

src_compile() {
	distutils-r1_src_compile
	elisp_src_compile

	if use doc; then
		VARTEXFONTS="${T}"/fonts emake RST2LATEX=rst2latex.py ${PN}.pdf
	fi
}

src_install() {
	distutils-r1_src_install
	elisp_src_install

	use doc && dodoc ${PN}.pdf
}
