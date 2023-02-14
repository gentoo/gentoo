# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

[[ ${PV} == *_p20221008 ]] && COMMIT=9bfb9f0f566e937cc6a2f2913d1b56978b81dc99
NEED_EMACS=25.1

inherit elisp

DESCRIPTION="GNU Emacs major mode for editing Crystal programming language files"
HOMEPAGE="https://github.com/crystal-lang-tools/emacs-crystal-mode/"
SRC_URI="https://github.com/crystal-lang-tools/${PN}/archive/${COMMIT}.tar.gz
	-> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-${COMMIT}

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="app-emacs/flycheck"
BDEPEND="${RDEPEND}"

DOCS=( README.md )
SITEFILE="50${PN}-gentoo.el"

src_compile() {
	elisp_src_compile
	elisp-make-autoload-file
}
