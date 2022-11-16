# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=24

inherit elisp

DESCRIPTION="GNU Emacs major mode for editing PHP code"
HOMEPAGE="https://github.com/emacs-php/php-mode/"
SRC_URI="https://github.com/emacs-php/${PN}/archive/v${PV}.tar.gz
	-> ${P}.tar.gz"
S="${WORKDIR}"/${P}/lisp

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos"

DOCS=( ../AUTHORS.md ../CHANGELOG.md ../CONTRIBUTING.md ../README{,.ja}.md ../docs )
SITEFILE="50${PN}-gentoo.el"

src_test() {
	touch ../tests/project/1/.git || die
	${EMACS} ${EMACSFLAGS} -L . -L ../tests -l ../tests/php-mode-test.el \
		-f ert-run-tests-batch-and-exit || die "tests run failed"
}
