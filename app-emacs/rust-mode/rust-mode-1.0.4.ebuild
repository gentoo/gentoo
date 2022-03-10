# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=24

inherit elisp

DESCRIPTION="A major emacs mode for editing Rust source code"
HOMEPAGE="https://github.com/rust-lang/rust-mode"
SRC_URI="https://github.com/rust-lang/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( MIT Apache-2.0 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md )
SITEFILE="50${PN}-gentoo.el"

src_test() {
	${EMACS} ${EMACSFLAGS} ${BYTECOMPFLAGS} \
		-l rust-mode.el -l rust-mode-tests.el \
		-f ert-run-tests-batch-and-exit || die "tests failed"
}
