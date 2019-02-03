# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit readme.gentoo elisp

DESCRIPTION="TECO interpreter for GNU Emacs"
HOMEPAGE="https://www.emacswiki.org/emacs/TECO"
# taken from: http://www.emacswiki.org/emacs/teco.el
SRC_URI="mirror://gentoo/${P}.el.bz2"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"

ELISP_PATCHES="${P}-minibuffer-prompt.patch
	${P}-emacs-24.patch"
SITEFILE="50${PN}-gentoo.el"
DOC_CONTENTS="To be able to invoke Teco directly, define a keybinding
	for teco:command in your ~/.emacs file, e.g.:
	\\n\\t(global-set-key \"\\C-z\" 'teco:command)
	\\nSee ${SITELISP}/${PN}/teco.el for documentation."
