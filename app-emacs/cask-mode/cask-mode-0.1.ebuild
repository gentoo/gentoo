# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=24.3

inherit elisp

DESCRIPTION="Major mode for editing Cask files for Emacs"
HOMEPAGE="https://github.com/Wilfred/cask-mode/"
SRC_URI="https://github.com/Wilfred/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? (
		app-emacs/assess
		app-emacs/ert-runner
	)
"

DOCS=( README.md )
SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	elisp_src_prepare

	# Silence a broken test
	sed "s|ert-deftest cask-mode-highlight-comment|lambda|" \
		-i test/${PN}-test.el || die
}

src_test() {
	ert-runner -L . -L test --reporter ert+duration --script test || die
}
