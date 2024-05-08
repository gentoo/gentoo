# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=27.1

inherit elisp

DESCRIPTION="UI modules for lsp-mode"
HOMEPAGE="https://emacs-lsp.github.io/lsp-ui/
	https://github.com/emacs-lsp/lsp-ui/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/emacs-lsp/${PN}.git"
else
	SRC_URI="https://github.com/emacs-lsp/${PN}/archive/${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="~amd64 ~arm64"
fi

LICENSE="GPL-3"
SLOT="0"

RDEPEND="
	app-emacs/dash
	app-emacs/flycheck
	app-emacs/lsp-mode
	app-emacs/markdown-mode
"
BDEPEND="
	${RDEPEND}
"

ELISP_REMOVE="
	Makefile
"

DOCS=( README.md )
SITEFILE="50${PN}-gentoo.el"
