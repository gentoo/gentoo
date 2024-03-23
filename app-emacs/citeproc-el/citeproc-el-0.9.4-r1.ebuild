# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=26

inherit elisp

DESCRIPTION="CSL 1.0.2 Citation Processor for Emacs"
HOMEPAGE="https://github.com/andras-simonyi/citeproc-el"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/andras-simonyi/${PN}.git"
else
	SRC_URI="https://github.com/andras-simonyi/${PN}/archive/${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="amd64"
fi

LICENSE="GPL-3+"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=app-editors/emacs-26:*[libxml2]
	app-emacs/compat
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

elisp-enable-tests ert test						\
	-l citeproc-test-human.el					\
	-l test/citeproc-test-int-biblatex.el		\
	-l test/citeproc-test-int-formatters.el
