# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

COMMIT=6c1d63511fb2b3b3f2e342eff6a375d78be6c12c
NEED_EMACS=25.1

inherit optfeature elisp

DESCRIPTION="Run an inferior Julia REPL in a terminal inside Emacs"
HOMEPAGE="https://github.com/tpapp/julia-repl/"
SRC_URI="https://github.com/tpapp/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-${COMMIT}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="app-emacs/s"
RDEPEND="
	${BDEPEND}
	app-emacs/julia-mode
"

DOCS=( CHANGELOG.md README.md )
PATCHES=( "${FILESDIR}"/${PN}-force-compile.patch )
SITEFILE="50${PN}-gentoo.el"

src_test() {
	${EMACS} ${EMACSFLAGS} ${BYTECOMPFLAGS}  \
			 -l ert -l ./${PN}-tests.el  \
			 -f ert-run-tests-batch-and-exit || die "tests failed"
}

src_install() {
	rm ./${PN}-tests.el || die

	elisp_src_install
}

pkg_postinst() {
	elisp_pkg_postinst

	optfeature "running Julia inside VTerm" app-emacs/vterm
}
