# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit python-single-r1 vim-plugin vcs-snapshot

DESCRIPTION="vim plugin: aid Lisp development by providing a SLIME-like Lisp and Clojure REPL"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=2531"
SRC_URI="https://bitbucket.org/kovisoft/${PN}/get/${PV}.tar.bz2 -> ${P}.tar.bz2"
LICENSE="public-domain"
KEYWORDS="amd64 x86"

RDEPEND="|| ( app-editors/vim[python,${PYTHON_USEDEP}] app-editors/gvim[python,${PYTHON_USEDEP}] )
	${PYTHON_DEPS}
	|| (
		dev-lisp/clisp
		dev-lang/clojure
		dev-lisp/abcl
		dev-lisp/clozurecl
		dev-lisp/ecls
		dev-lisp/sbcl
	)"

REQUIRED_USE=${PYTHON_REQUIRED_USE}

VIM_PLUGIN_HELPFILES="${PN}.txt"

src_prepare() {
	# remove emacs related files
	rm -r slime swank-clojure || die
}
