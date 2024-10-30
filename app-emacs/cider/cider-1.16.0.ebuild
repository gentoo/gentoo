# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp optfeature

DESCRIPTION="Clojure Interactive Development Environment for GNU Emacs"
HOMEPAGE="https://cider.mx/
	https://github.com/clojure-emacs/cider/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/clojure-emacs/${PN}.git"
else
	SRC_URI="https://github.com/clojure-emacs/${PN}/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="amd64"
fi

LICENSE="GPL-3+"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	app-emacs/clojure-mode
	app-emacs/parseedn
	app-emacs/queue
	app-emacs/sesman
	app-emacs/spinner
	app-emacs/transient
"
BDEPEND="
	${RDEPEND}
"

# The "clojure-ts-mode" is currently unpackaged, so remove related tests.
ELISP_REMOVE="
	test/${PN}-jar-tests.el
	test/${PN}-repl-tests.el
	test/clojure-ts-mode/${PN}-connection-ts-tests.el
	test/clojure-ts-mode/${PN}-selector-ts-tests.el
	test/clojure-ts-mode/${PN}-util-ts-tests.el
	test/enrich/${PN}-docstring-tests.el
	test/integration/integration-tests.el
"

DOCS=( CHANGELOG.md README.md ROADMAP.md refcard )
SITEFILE="50${PN}-gentoo.el"

elisp-enable-tests buttercup test

src_install() {
	elisp_src_install

	optfeature "Connecting to leiningen REPL" \
		dev-java/leiningen dev-java/leiningen-bin
}
