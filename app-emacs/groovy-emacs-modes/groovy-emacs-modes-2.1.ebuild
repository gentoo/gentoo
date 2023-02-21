# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=24.3

inherit elisp

DESCRIPTION="Groovy major mode, grails minor mode, and a groovy inferior mode"
HOMEPAGE="https://github.com/Groovy-Emacs-Modes/groovy-emacs-modes/"
SRC_URI="https://github.com/Groovy-Emacs-Modes/${PN}/archive/${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

DOCS=( README.md groovy-mode.png )
SITEFILE="50${PN}-gentoo.el"

RDEPEND="
	app-emacs/s
	app-emacs/dash
"
BDEPEND="
	${RDEPEND}
	test? (
		app-emacs/ert-runner
		app-emacs/f
		app-emacs/shut-up
		app-emacs/undercover
	)
"

src_compile() {
	elisp_src_compile
	elisp-make-autoload-file
}

src_test() {
	ert-runner -L . -L test --reporter ert+duration --script test || die
}
