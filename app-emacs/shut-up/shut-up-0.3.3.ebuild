# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Reduce Emacs output of messages"
HOMEPAGE="https://github.com/cask/shut-up/"
SRC_URI="https://github.com/cask/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~ppc64 ~riscv ~sparc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? (
		app-emacs/f
		app-emacs/s
	)
"

DOCS=( README.md )
SITEFILE="50${PN}-gentoo.el"

src_test() {
	${EMACS} ${EMACSFLAGS} -L . -L test -l test/${PN}-test.el \
			 -f ert-run-tests-batch-and-exit || die "tests failed"
}
