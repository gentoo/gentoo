# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=27.1

inherit elisp

DESCRIPTION="Emacs package to quickly find and act on bibliographic references"
HOMEPAGE="https://github.com/emacs-citar/citar/"
SRC_URI="https://github.com/emacs-citar/${PN}/archive/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	app-emacs/citeproc-el
	app-emacs/parsebib
"
BDEPEND="${RDEPEND}"

# Embark integration has it's own package on MELPA, and it is probably better
# to split them. https://melpa.org/#/citar-embark
ELISP_REMOVE="citar-embark.el"

DOCS=( CHANGELOG.org CONTRIBUTING.org README.org images )
SITEFILE="50${PN}-gentoo.el"

src_compile() {
	elisp_src_compile
	elisp-make-autoload-file
}

src_test() {
	${EMACS} ${EMACSFLAGS} -L . -L test \
		-l test/citar-file-test.el \
		-l test/citar-format-test.el \
		-l test/citar-test.el \
		-f ert-run-tests-batch-and-exit || die
}
