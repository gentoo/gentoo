# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

COMMIT=2367fba7b3b2340364a30cd6de7f3eb6bb9898a3

inherit elisp

DESCRIPTION="Emacs library to convert strings into ansi"
HOMEPAGE="https://github.com/rejeep/ansi.el/"
SRC_URI="https://github.com/rejeep/${PN}.el/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${PN}.el-${COMMIT}

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? (
		app-emacs/dash
		app-emacs/el-mock
		app-emacs/f
		app-emacs/s
		app-emacs/undercover
	)
"

DOCS=( README.markdown )
SITEFILE="50${PN}-gentoo.el"

src_test() {
	${EMACS} ${EMACSFLAGS} -L . -L test \
			 -l ansi.el -l test/ansi-color-test.el -l test/ansi-csi-test.el \
			 -l test/ansi-format-test.el -l test/ansi-init.el \
			 -l test/ansi-on-color-test.el -l test/ansi-style-test.el \
			 -l test/ansi-test.el -l test/test-helper.el \
			 -f ert-run-tests-batch-and-exit || die "tests failed"
}
