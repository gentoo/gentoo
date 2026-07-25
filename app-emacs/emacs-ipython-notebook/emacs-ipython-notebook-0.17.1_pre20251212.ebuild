# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..14} )

inherit elisp readme.gentoo-r1 python-single-r1

DESCRIPTION="Jupyter notebook client in Emacs"
HOMEPAGE="https://github.com/millejoh/emacs-ipython-notebook/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/millejoh/${PN}"
else
	[[ "${PV}" == *20251212 ]] && COMMIT="8fa836fcd1c22f45d36249b09590b32a890f2b9e"

	SRC_URI="https://github.com/millejoh/${PN}/archive/${COMMIT}.tar.gz
		-> ${P}.gh.tar.gz"
	S="${WORKDIR}/${PN}-${COMMIT}"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	>=app-emacs/anaphora-1.0.4
	>=app-emacs/dash-2.13.0
	>=app-emacs/deferred-0.5
	>=app-emacs/polymode-0.2.2
	>=app-emacs/request-0.3.3
	>=app-emacs/websocket-1.12
	>=app-emacs/with-editor-3.4.9
	$(python_gen_cond_dep '
		dev-python/ipython[${PYTHON_USEDEP}]
		dev-python/notebook[${PYTHON_USEDEP}]
		dev-python/tornado[${PYTHON_USEDEP}]
	')
"
BDEPEND="
	${RDEPEND}
	test? (
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

elisp-enable-tests ert-runner test

pkg_setup() {
	#  * ACCESS DENIED:  open_wr: ~/.config/python/jupyter/migrated
	unset JUPYTER_CONFIG_DIR

	elisp_pkg_setup
	python-single-r1_pkg_setup
}

src_compile() {
	local -x BYTECOMPFLAGS="-L lisp"

	elisp-compile ./lisp/*.el
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
