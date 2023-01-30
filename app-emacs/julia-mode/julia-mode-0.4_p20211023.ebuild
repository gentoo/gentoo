# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

COMMIT=47f43f7d839019cac3ba6559d93b29487ca118cb
NEED_EMACS=24.3

inherit elisp

DESCRIPTION="Emacs major mode for the Julia programming language"
HOMEPAGE="https://github.com/JuliaEditorSupport/julia-emacs/"
SRC_URI="https://github.com/JuliaEditorSupport/julia-emacs/archive/${COMMIT}.tar.gz
		-> ${P}.tar.gz"
S="${WORKDIR}"/julia-emacs-${COMMIT}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DOCS=( CHANGELOG.md README.md )
SITEFILE="50${PN}-gentoo.el"

src_test() {
	${EMACS} ${EMACSFLAGS} ${BYTECOMPFLAGS}  \
			 -l ert -l ./julia-mode-tests.el  \
			 -f ert-run-tests-batch-and-exit || die "tests failed"
}

src_install() {
	rm ./julia-mode-tests.el{,c} || die

	elisp_src_install
}
