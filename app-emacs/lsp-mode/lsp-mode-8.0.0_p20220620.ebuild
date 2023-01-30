# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

COMMIT=9957623d93b13fabaca8ba35b85da8fcceaeef69
NEED_EMACS=26.1

inherit elisp

DESCRIPTION="Emacs client/library for the Language Server Protocol"
HOMEPAGE="https://emacs-lsp.github.io/lsp-mode/"
SRC_URI="https://github.com/emacs-lsp/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-${COMMIT}

LICENSE="GPL-3+"
KEYWORDS="~amd64"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=app-emacs/dash-2.18.0
	>=app-emacs/f-0.20.0
	app-emacs/ht
	app-emacs/lv
	app-emacs/markdown-mode
	app-emacs/spinner
"
BDEPEND="
	${RDEPEND}
	test? (
		app-emacs/deferred
		app-emacs/ecukes
		app-emacs/el-mock
		app-emacs/ert-runner
		app-emacs/espuds
		app-emacs/flycheck
		app-emacs/undercover
	)
"

DOCS=( AUTHORS CHANGELOG.org README.md refcard )
BYTECOMPFLAGS="-L . -L clients"
ELISP_REMOVE="test/lsp-clangd-test.el test/lsp-common-test.el
	test/lsp-integration-test.el"  # Remove failing tests
SITEFILE="50${PN}-gentoo.el"

src_compile() {
	elisp_src_compile
	elisp-compile clients/*.el
}

src_test() {
	ert-runner -L clients --reporter ert+duration -t "!no-win" -t "!org" || die
}

src_install() {
	elisp_src_install
	elisp-install ${PN}/clients clients/*
}
