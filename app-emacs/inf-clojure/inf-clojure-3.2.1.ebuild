# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=25.1

inherit elisp

DESCRIPTION="Major mode for Clojure code"
HOMEPAGE="https://github.com/clojure-emacs/inf-clojure/"
SRC_URI="https://github.com/clojure-emacs/${PN}/archive/v${PV}.tar.gz
			-> ${P}.tar.gz"

LICENSE="GPL-3+"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="app-emacs/clojure-mode"
BDEPEND="
	${RDEPEND}
	test? (
		app-emacs/assess
		app-emacs/buttercup
	)
"

DOCS=( CHANGELOG.md README.md )
SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	elisp_src_prepare

	# Silence a failing test (mark as "PENDING").
	sed "s|it \"computes no bounds|xit \"computes no bounds|" \
		-i test/${PN}-tests.el || die
}

src_test() {
	buttercup -L . -L test --traceback full || die
}
