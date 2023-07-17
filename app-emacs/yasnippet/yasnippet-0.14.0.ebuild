# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp readme.gentoo-r1

DESCRIPTION="Yet another snippet extension for Emacs"
HOMEPAGE="https://joaotavora.github.io/yasnippet/"
SRC_URI="https://github.com/joaotavora/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="doc"

SITEFILE="50${PN}-gentoo-0.13.0.el"

src_test() {
	${EMACS} ${EMACSFLAGS} -L . -l yasnippet-tests \
		-f ert-run-tests-batch-and-exit
}

src_install() {
	elisp-install ${PN} yasnippet.{el,elc} yasnippet-debug.{el,elc}
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	dodoc CONTRIBUTING.md NEWS README.mdown
	use doc && dodoc -r doc/*

	local DOC_CONTENTS="Add the following to your ~/.emacs to use YASnippet:
		\n\t(require 'yasnippet)
		\n\t(yas-global-mode 1)
		\n\nYASnippet no longer bundles snippets directly. Install the package
		app-emacs/yasnippet-snippets for a collection of snippets."
	readme.gentoo_create_doc
}
