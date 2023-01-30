# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

COMMIT=744e076f0bea1c5ddc49f92397d9aa98ffa7eff8
NEED_EMACS=24.4

inherit elisp

DESCRIPTION="Emacs major mode for the Nim programming language support"
HOMEPAGE="https://github.com/nim-lang/nim-mode/"
SRC_URI="https://github.com/nim-lang/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-${COMMIT}

LICENSE="GPL-3+"
KEYWORDS="~amd64"
SLOT="0"
RESTRICT="test"  # some test are broken

RDEPEND="
	app-emacs/commenter
	app-emacs/epc
"
BDEPEND="${RDEPEND}"
PDEPEND="app-emacs/flycheck-nimsuggest"

DOCS=( README.md starterKit.nims )
SITEFILE="50${PN}-gentoo.el"
