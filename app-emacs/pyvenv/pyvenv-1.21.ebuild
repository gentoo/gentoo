# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Python virtual environment interface for Emacs"
HOMEPAGE="https://github.com/jorgenschaefer/pyvenv/"
SRC_URI="https://github.com/jorgenschaefer/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="test? ( app-emacs/mocker )"

DOCS=( README.md )
SITEFILE="50${PN}-gentoo.el"

src_test() {
	# Other tests require special Python Venv setup
	${EMACS} ${EMACSFLAGS} -L . -l ./${PN}.el -L ./test \
			 -l ./test/pyvenv-mode-test.el -l ./test/pyvenv-hook-dir-test.el \
			 -f ert-run-tests-batch-and-exit || die "tests failed"
}
