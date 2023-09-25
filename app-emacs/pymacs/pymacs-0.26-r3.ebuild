# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Can not use "DISTUTILS_USE_PEP517" because we need "DISTUTILS_IN_SOURCE_BUILD".
DISTUTILS_IN_SOURCE_BUILD=1
PYTHON_COMPAT=( python3_{9..11} )

inherit elisp distutils-r1

DESCRIPTION="A tool that allows both-side communication between Python and Emacs Lisp"
HOMEPAGE="https://www.emacswiki.org/emacs/PyMacs"
SRC_URI="https://github.com/dgentry/${PN^}/archive/v${PV}.tar.gz
	-> ${P}.tar.gz"
S="${WORKDIR}"/${P^}

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 arm ~hppa ~ia64 ppc ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="doc"

BDEPEND="
	doc? (
		>=dev-python/docutils-0.7
		virtual/latex-base
	)
"

SITEFILE="50${PN}-gentoo.el"

# called by distutils-r1 for every python implementation
python_configure() {
	# pre-process the files but don't run distutils
	emake PYSETUP=: PYTHON=${EPYTHON}
}

# called once
python_compile_all() {
	elisp_src_compile

	if use doc; then
		VARTEXFONTS="${T}"/fonts emake RST2LATEX=rst2latex.py pymacs.pdf
	fi
}

python_install_all() {
	elisp_src_install

	distutils-r1_python_install_all

	dodoc pymacs.rst

	use doc && dodoc pymacs.pdf
}
