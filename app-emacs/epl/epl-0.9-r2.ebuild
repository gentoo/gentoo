# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=24

inherit elisp

DESCRIPTION="A convenient high-level API for package.el"
HOMEPAGE="https://github.com/cask/epl"
SRC_URI="https://github.com/cask/epl/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x64-macos"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="test? ( app-emacs/f )"

DOCS=( README.md )
SITEFILE="50epl-gentoo.el"

src_test() {
	${EMACS} ${EMACSFLAGS} -L . -L test -l epl.el -l test/epl-test.el \
		-f ert-run-tests-batch-and-exit || die
}
