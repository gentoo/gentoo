# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit elisp readme.gentoo-r1

DESCRIPTION="Yet another snippet extension for Emacs"
HOMEPAGE="http://joaotavora.github.com/yasnippet/"
SRC_URI="https://github.com/joaotavora/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

SITEFILE="50${PN}-gentoo-${PV}.el"

src_test() {
	${EMACS} ${EMACSFLAGS} -L . -l yasnippet-tests \
		-f ert-run-tests-batch-and-exit
}

src_install() {
	elisp-install ${PN} yasnippet.el{,c} yasnippet-debug.el{,c}
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	dodoc CONTRIBUTING.md NEWS README.mdown
	use doc && dodoc -r doc/*

	DOC_CONTENTS="Add the following to your ~/.emacs to use YASnippet:
		\n\t(require 'yasnippet)
		\n\t(yas-global-mode 1)
		\n\nYASnippet no longer bundles snippets directly. Install the package
		app-emacs/yasnippet-snippets for a collection of snippets."
	readme.gentoo_create_doc
}
