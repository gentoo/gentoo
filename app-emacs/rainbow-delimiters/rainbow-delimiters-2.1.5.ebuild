# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=24.1  # needs ERT for tests

inherit elisp readme.gentoo-r1

DESCRIPTION="Highlight nested parentheses, brackets, and braces according to their depth"
HOMEPAGE="https://github.com/Fanael/rainbow-delimiters/"
SRC_URI="https://github.com/Fanael/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

SITEFILE="50${PN}-gentoo.el"
DOC_CONTENTS="To start the mode automatically in foo-mode,
	add the following to your init file:
	\n\t(add-hook 'foo-mode-hook #'rainbow-delimiters-mode)
	\nTo start the mode automatically in most programming modes
	(Emacs 24 and above):
	\n\t(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)"

src_test() {
	# EMACS_VERSION is for GitHub CI, it can be left blank
	EMACS_VERSION="" sh ./run-tests.sh || die
}

src_install() {
	elisp-install ${PN} ${PN}.el{,c}
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"

	einstalldocs
	readme.gentoo_create_doc
}
