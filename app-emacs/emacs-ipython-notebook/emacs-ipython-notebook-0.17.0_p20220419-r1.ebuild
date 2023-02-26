# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# NOTICE: Check package version in "lisp/ein-pkg.el".
# NOTICE: File "lisp/ein-pkg.el" is needed by the "ein:dev-sys-info" function.

EAPI=8

COMMIT=388c8f753cfb99b4f82acbdff26bbe27189d2299
NEED_EMACS=25
PYTHON_COMPAT=( python3_{9..11} )

inherit elisp readme.gentoo-r1 python-single-r1

DESCRIPTION="Jupyter notebook client in Emacs"
HOMEPAGE="https://github.com/millejoh/emacs-ipython-notebook/"
SRC_URI="https://github.com/millejoh/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-${COMMIT}

LICENSE="GPL-3+"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	app-emacs/anaphora
	app-emacs/dash
	app-emacs/deferred
	app-emacs/polymode
	app-emacs/request
	app-emacs/websocket
	app-emacs/with-editor
	$(python_gen_cond_dep '
		dev-python/ipython[${PYTHON_USEDEP}]
		dev-python/notebook[${PYTHON_USEDEP}]
		dev-python/tornado[${PYTHON_USEDEP}]
	')
"
BDEPEND="
	${RDEPEND}
	test? (
		app-emacs/ert-runner
		app-emacs/mocker
	)
"

DOCS=( README.rst thumbnail.png )
DOC_CONTENTS="There may be problems with connecting to Jupyter Notebooks
	because of the tokens, in that case you can try running	\"jupyter
	notebook\" with --NotebookApp.token=\"\" (and --NotebookApp.ip=127.0.0.1 to
	limit connections only to local machine), but be warned that this can
	compromise your system if used without caution! For reference check out
	https://github.com/millejoh/emacs-ipython-notebook/issues/838"

SITEFILE="50${PN}-gentoo.el"

pkg_setup() {
	elisp_pkg_setup
	python-single-r1_pkg_setup
}

src_compile() {
	BYTECOMPFLAGS="-L lisp" elisp-compile lisp/*.el
}

src_test() {
	ert-runner -L lisp -L test -l test/testein.el \
		--reporter ert+duration test/test-ein*.el || die
}

src_install() {
	elisp-install ${PN} lisp/*.el{,c}
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"

	readme.gentoo_create_doc
}
