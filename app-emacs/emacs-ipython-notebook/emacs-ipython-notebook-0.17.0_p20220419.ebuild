# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# NOTICE: Check package version in "lisp/ein-pkg.el".
# NOTICE: File "lisp/ein-pkg.el" is needed by the "ein:dev-sys-info" function.

EAPI=8

H=388c8f753cfb99b4f82acbdff26bbe27189d2299
NEED_EMACS=25

inherit elisp readme.gentoo-r1

DESCRIPTION="Jupyter notebook client in Emacs"
HOMEPAGE="https://github.com/millejoh/emacs-ipython-notebook/"
SRC_URI="https://github.com/millejoh/${PN}/archive/${H}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-${H}

LICENSE="GPL-3+"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	app-emacs/anaphora
	app-emacs/dash
	app-emacs/deferred
	app-emacs/polymode
	app-emacs/request
	app-emacs/websocket
	app-emacs/with-editor
	dev-python/ipython
	dev-python/notebook
	www-servers/tornado
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
