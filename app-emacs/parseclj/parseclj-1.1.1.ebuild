# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Clojure Parser for Emacs Lisp"
HOMEPAGE="https://github.com/clojure-emacs/parseclj/"

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

DOCS=( CHANGELOG.md DESIGN.md README.md )
SITEFILE="50${PN}-gentoo.el"

elisp-enable-tests ert-runner test
