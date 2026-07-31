# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

NEED_EMACS="28"

inherit elisp optfeature

DESCRIPTION="Clojure Interactive Development Environment for GNU Emacs"
HOMEPAGE="https://cider.mx/
	https://github.com/clojure-emacs/cider/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/clojure-emacs/${PN}"
else
	SRC_URI="https://github.com/clojure-emacs/${PN}/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-3+"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=app-emacs/clojure-mode-5.19.0
	>=app-emacs/compat-30.0
	>=app-emacs/parseedn-1.2.1
	>=app-emacs/queue-0.2
	>=app-emacs/sesman-0.3.2
	>=app-emacs/spinner-1.7
	>=app-emacs/transient-0.4.1
"
BDEPEND="
	${RDEPEND}
"

ELISP_REMOVE="
	test/${PN}-find-tests.el
	test/${PN}-repl-tests.el
	test/${PN}-tests.el
	test/nrepl-bencode-tests.el
	test/nrepl-client-tests.el
"
DOCS=( CHANGELOG.md README.md ROADMAP.md refcard )
SITEFILE="50${PN}-gentoo.el"

elisp-enable-tests buttercup test

src_prepare() {
	# The "clojure-ts-mode" is currently unpackaged, so remove related tests.
	rm -f -r test/clojure-ts-mode/* || die

	mv lisp/*.el ./ || die
	echo "" > test/integration/integration-tests.el || die

	elisp_src_prepare
}

src_install() {
	elisp_src_install
	optfeature "Connecting to leiningen REPL" dev-java/leiningen dev-java/leiningen-bin
}
