# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
NEED_EMACS=24

inherit elisp

DESCRIPTION="A major emacs mode for editing Rust source code"
HOMEPAGE="https://github.com/rust-lang/rust-mode"
SRC_URI="https://github.com/rust-lang/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( MIT Apache-2.0 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"

SITEFILE="50${PN}-gentoo.el"
DOCS="README.md"

src_test() {
	${EMACS} ${EMACSFLAGS} ${BYTECOMPFLAGS} \
		-l rust-mode.el -l rust-mode-tests.el \
		-f ert-run-tests-batch-and-exit || die "tests failed"
}

src_install() {
	elisp-install ${PN} rust-mode.{el,elc}
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"
}
