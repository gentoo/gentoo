# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Groovy major mode, grails minor mode, and a groovy inferior mode"
HOMEPAGE="https://github.com/Groovy-Emacs-Modes/groovy-emacs-modes/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/Groovy-Emacs-Modes/${PN}.git"
else
	SRC_URI="https://github.com/Groovy-Emacs-Modes/${PN}/archive/${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

DOCS=( README.md groovy-mode.png )
SITEFILE="50${PN}-gentoo.el"

RDEPEND="
	app-emacs/s
	app-emacs/dash
"
BDEPEND="
	${RDEPEND}
	test? (
		app-emacs/f
		app-emacs/shut-up
		app-emacs/undercover
	)
"

elisp-enable-tests ert-runner test

src_compile() {
	elisp_src_compile
	elisp-make-autoload-file
}
