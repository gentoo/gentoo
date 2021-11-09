# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=26.1

inherit elisp

IUSE=""

DESCRIPTION="UI modules for lsp-mode"
HOMEPAGE="https://emacs-lsp.github.io/lsp-ui/"
SRC_URI="https://github.com/emacs-lsp/lsp-ui/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

SITEFILE="50${PN}-gentoo.el"

RDEPEND="
	>=app-emacs/dash-2.18.0
	app-emacs/flycheck
	>=app-emacs/lsp-mode-6.0
	>=app-emacs/markdown-mode-2.3
"
DEPEND=${RDEPEND}

# Requires unpackaged dependencies, e.g. Cask
RESTRICT="test"

DOCS="README.md"
