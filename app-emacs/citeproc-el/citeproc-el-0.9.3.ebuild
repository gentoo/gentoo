# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=26

inherit elisp

DESCRIPTION="CSL 1.0.2 Citation Processor for Emacs"
HOMEPAGE="https://github.com/andras-simonyi/citeproc-el"
SRC_URI="https://github.com/andras-simonyi/${PN}/archive/${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=app-editors/emacs-26:*[libxml2]
	app-emacs/dash
	app-emacs/f
	app-emacs/parsebib
	app-emacs/queue
	app-emacs/s
	app-emacs/string-inflection
"
BDEPEND="
	${RDEPEND}
	test? (
		app-emacs/ht
		app-emacs/yaml
	)
"

DOCS=( README.md )
SITEFILE="50${PN}-gentoo.el"

src_test() {
	${EMACS} ${EMACSFLAGS} -L . -L test \
		-l citeproc-test-human.el \
		-l test/citeproc-test-int-biblatex.el \
		-l test/citeproc-test-int-formatters.el \
		-f ert-run-tests-batch-and-exit || die
}
