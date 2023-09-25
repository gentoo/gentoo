# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Emacs Java IDE using Eclipse JDT Language Server"
HOMEPAGE="https://emacs-lsp.github.io/lsp-java/"
SRC_URI="https://github.com/emacs-lsp/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
KEYWORDS="~amd64"
SLOT="0"
RESTRICT="test"  # Tests are unnecessary, they run "build compile checkdoc lint"

RDEPEND="
	app-emacs/dap-mode
	app-emacs/dash
	app-emacs/f
	app-emacs/ht
	app-emacs/lsp-mode
	app-emacs/markdown-mode
	app-emacs/request
	app-emacs/treemacs
"
BDEPEND="${RDEPEND}"

DOCS=( README.md images )
PATCHES=( "${FILESDIR}"/${PN}-icons.patch )
SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	elisp_src_prepare

	sed "s|@SITEETC@|${SITEETC}/${PN}|" -i ${PN}.el -i lsp-jt.el || die
}

src_install() {
	elisp_src_install

	insinto ${SITEETC}/${PN}
	doins -r icons
}
