# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Jump to arbitrary positions in visible text and quickly select"
HOMEPAGE="https://github.com/abo-abo/avy"
SRC_URI="https://github.com/abo-abo/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 x86"

SITEFILE="50${PN}-gentoo.el"

src_test() {
	${EMACS} ${EMACSFLAGS} -l avy.el -l avy-test.el \
			 -f ert-run-tests-batch-and-exit || die "tests failed"
}

src_install() {
	elisp-install ${PN} avy.{el,elc}
}
