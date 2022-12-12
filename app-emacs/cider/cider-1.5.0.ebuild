# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=26

inherit elisp optfeature

DESCRIPTION="Clojure Interactive Development Environment for GNU Emacs"
HOMEPAGE="https://cider.mx/
	https://github.com/clojure-emacs/cider/"
SRC_URI="https://github.com/clojure-emacs/${PN}/archive/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="GPL-3+"
KEYWORDS="~amd64"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	app-emacs/clojure-mode
	app-emacs/parseedn
	app-emacs/queue
	app-emacs/sesman
	app-emacs/spinner
"
BDEPEND="
	${RDEPEND}
	test? ( app-emacs/buttercup )
"

ELISP_REMOVE="test/${PN}-jar-test.el"
DOCS=( CHANGELOG.md README.md ROADMAP.md refcard )
SITEFILE="50${PN}-gentoo.el"

src_test() {
	buttercup -L . -L test --traceback full || die "tests failed"
}

src_install() {
	elisp_src_install

	optfeature "Connecting to leiningen REPL"               \
		dev-java/leiningen dev-java/leiningen-bin
}
