# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=25.1

inherit elisp

DESCRIPTION="Major mode for Clojure code"
HOMEPAGE="https://github.com/clojure-emacs/clojure-mode/"
SRC_URI="https://github.com/clojure-emacs/${PN}/archive/v${PV}.tar.gz
			-> ${P}.tar.gz"

LICENSE="GPL-3+"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? (
		app-emacs/s
		app-emacs/buttercup
		app-emacs/paredit
	)
"

DOCS=( README.md doc )
SITEFILE="50${PN}-gentoo.el"

src_test() {
	buttercup -L . -L test --traceback full || die
}
