# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=26.1

inherit elisp

DESCRIPTION="Debug Adapter Protocol mode"
HOMEPAGE="https://github.com/emacs-lsp/dap-mode/"
SRC_URI="https://github.com/emacs-lsp/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
KEYWORDS="~amd64"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	app-emacs/bui
	app-emacs/dash
	app-emacs/f
	app-emacs/ht
	app-emacs/hydra
	app-emacs/lsp-mode
	app-emacs/lsp-treemacs
	app-emacs/posframe
	app-emacs/s
"
BDEPEND="
	${RDEPEND}
	test? ( app-emacs/ert-runner )
"

DOCS=( CHANGELOG.org README.org )
PATCHES=( "${FILESDIR}"/${PN}-dap-ui-images-root-dir.patch )
SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	elisp_src_prepare

	sed "s|@SITEETC@|${SITEETC}/${PN}|" -i dap-ui.el || die
}

src_test() {
	ert-runner -L . -L test --reporter ert+duration || die
}

src_install() {
	elisp_src_install

	insinto ${SITEETC}/${PN}
	doins -r icons
}
