# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

NEED_EMACS="28.1"

inherit elisp

DESCRIPTION="Emacs client/library for the Language Server Protocol"
HOMEPAGE="https://emacs-lsp.github.io/lsp-mode/
	https://github.com/emacs-lsp/lsp-mode/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/emacs-lsp/${PN}"
else
	SRC_URI="https://github.com/emacs-lsp/${PN}/archive/${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="~amd64 ~arm64"
fi

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="
	>=app-emacs/dash-2.18.0
	>=app-emacs/f-0.20.0
	>=app-emacs/ht-2.3
	>=app-emacs/lv-0.15.0
	>=app-emacs/markdown-mode-2.3
	>=app-emacs/spinner-1.7.3
"
BDEPEND="
	${RDEPEND}
	test? (
		app-emacs/deferred
		app-emacs/ecukes
		app-emacs/el-mock
		app-emacs/espuds
		app-emacs/flycheck
		app-emacs/undercover
	)
"

BYTECOMPFLAGS="-L . -L clients"

# Remove failing tests.
ELISP_REMOVE="
	test/lsp-clangd-test.el
	test/lsp-common-test.el
	test/lsp-integration-test.el
	test/lsp-mock-server-test.el
"

DOCS=( AUTHORS CHANGELOG.org README.md refcard )
SITEFILE="50${PN}-gentoo.el"

elisp-enable-tests ert-runner "${S}" -t "!no-win" -t "!org"

src_compile() {
	elisp_src_compile
	elisp-compile ./clients/*.el
}

src_install() {
	elisp_src_install
	elisp-install "${PN}/clients" ./clients/*
}
