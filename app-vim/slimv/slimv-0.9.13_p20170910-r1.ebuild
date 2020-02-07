# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit python-single-r1 vim-plugin vcs-snapshot

# Commit Date: July 10th 2017
COMMIT="acf9b30be71c54db4f4875d257b905941ca69ed8"

DESCRIPTION="vim plugin: aid Lisp development by providing a SLIME-like Lisp and Clojure REPL"
HOMEPAGE="https://www.vim.org/scripts/script.php?script_id=2531 https://github.com/kovisoft/slimv"
SRC_URI="https://github.com/kovisoft/slimv/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
LICENSE="public-domain"
KEYWORDS="amd64 x86"

RDEPEND="
	|| (
		app-editors/vim[python,${PYTHON_SINGLE_USEDEP}]
		app-editors/gvim[python,${PYTHON_SINGLE_USEDEP}]
	)
	${PYTHON_DEPS}
	|| (
		dev-lisp/abcl
		dev-lisp/ecls
		dev-lisp/sbcl
		dev-lisp/clisp
		dev-lang/clojure
		dev-lisp/clozurecl
	)"

REQUIRED_USE=${PYTHON_REQUIRED_USE}

VIM_PLUGIN_HELPFILES="${PN}.txt"

src_prepare() {
	default
	# remove emacs related files
	rm -r slime swank-clojure || die
}
