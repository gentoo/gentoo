# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=26.1

inherit elisp

DESCRIPTION="Integration between lsp-mode and treemacs"
HOMEPAGE="https://github.com/emacs-lsp/lsp-treemacs/"
SRC_URI="https://github.com/emacs-lsp/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
KEYWORDS="~amd64"
SLOT="0"

RDEPEND="
	app-emacs/dash
	app-emacs/f
	app-emacs/ht
	app-emacs/lsp-mode
	app-emacs/treemacs
"
BDEPEND="${RDEPEND}"

DOCS=( README.org screenshots )
PATCHES=( "${FILESDIR}"/${PN}-themes-icon-directory.patch )
SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	elisp_src_prepare

	sed "s|@SITEETC@|${SITEETC}/${PN}|" -i ${PN}-themes.el || die
}

src_install() {
	elisp_src_install

	insinto ${SITEETC}/${PN}
	doins -r icons
}
