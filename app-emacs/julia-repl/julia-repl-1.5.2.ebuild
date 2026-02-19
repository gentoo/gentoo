# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit optfeature elisp

DESCRIPTION="Run an inferior Julia REPL in a terminal inside Emacs"
HOMEPAGE="https://github.com/tpapp/julia-repl/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/tpapp/${PN}"
else
	SRC_URI="https://github.com/tpapp/${PN}/archive/refs/tags/${PV}.tar.gz
		-> ${P}.gh.tar.gz"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="MIT"
SLOT="0"

BDEPEND="
	app-emacs/s
"
RDEPEND="
	${BDEPEND}
	app-emacs/julia-mode
"

PATCHES=( "${FILESDIR}/${PN}-force-compile.patch" )

DOCS=( CHANGELOG.md README.md )
SITEFILE="50${PN}-gentoo.el"

src_test() {
	${EMACS} ${EMACSFLAGS} ${BYTECOMPFLAGS}  \
			 -l ert -l ./${PN}-tests.el  \
			 -f ert-run-tests-batch-and-exit || die "tests failed"
}

src_install() {
	rm -f ./${PN}-tests.el* || die

	elisp_src_install
}

pkg_postinst() {
	elisp_pkg_postinst

	optfeature "running Julia inside VTerm" app-emacs/vterm
}
