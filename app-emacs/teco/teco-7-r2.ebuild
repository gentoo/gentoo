# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp readme.gentoo-r1

DESCRIPTION="TECO interpreter for GNU Emacs"
HOMEPAGE="https://www.emacswiki.org/emacs/TECO"
# taken from: https://www.emacswiki.org/emacs/teco.el
SRC_URI="mirror://gentoo/${P}.el.bz2"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"

PATCHES=("${FILESDIR}"/${P}-minibuffer-prompt.patch
	"${FILESDIR}"/${P}-emacs-24.patch
	"${FILESDIR}"/${P}-backquotes.patch)
SITEFILE="50${PN}-gentoo.el"
DOC_CONTENTS="To be able to invoke Teco directly, define a keybinding
	for teco:command in your ~/.emacs file, e.g.:
	\\n\\t(global-set-key \"\\C-z\" 'teco:command)
	\\nSee ${SITELISP}/${PN}/teco.el for documentation."
