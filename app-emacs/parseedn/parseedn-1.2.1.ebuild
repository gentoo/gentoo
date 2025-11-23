# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS="26"

inherit elisp

DESCRIPTION="EDN parser for Emacs Lisp"
HOMEPAGE="https://github.com/clojure-emacs/parseedn/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/clojure-emacs/${PN}.git"
else
	SRC_URI="https://github.com/clojure-emacs/${PN}/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="
	app-emacs/parseclj
"
BDEPEND="
	${RDEPEND}
"

# Remove bad tests.
ELISP_REMOVE="
	test/${PN}-test.el
"

DOCS=( CHANGELOG.md README.md )
SITEFILE="50${PN}-gentoo.el"

elisp-enable-tests ert-runner test
