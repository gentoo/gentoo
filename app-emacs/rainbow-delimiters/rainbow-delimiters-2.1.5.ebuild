# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp readme.gentoo-r1

DESCRIPTION="Highlight nested parentheses, brackets, and braces according to their depth"
HOMEPAGE="https://github.com/Fanael/rainbow-delimiters/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/Fanael/${PN}.git"
else
	SRC_URI="https://github.com/Fanael/${PN}/archive/${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

PATCHES=( "${FILESDIR}/${PN}-2.1.5-test.patch"  )

SITEFILE="50${PN}-gentoo.el"
DOC_CONTENTS="To start the mode automatically in foo-mode,
	add the following to your init file:
	\n\t(add-hook 'foo-mode-hook #'rainbow-delimiters-mode)
	\nTo start the mode automatically in most programming modes
	(Emacs 24 and above):
	\n\t(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)"

elisp-enable-tests ert .

src_install() {
	elisp-install "${PN}" ${PN}.el{,c}
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"

	einstalldocs
	readme.gentoo_create_doc
}
