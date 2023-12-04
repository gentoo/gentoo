# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Clojure Parser for Emacs Lisp"
HOMEPAGE="https://github.com/clojure-emacs/parseclj/"
SRC_URI="https://github.com/clojure-emacs/${PN}/archive/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="GPL-3+"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="test? ( app-emacs/ert-runner )"

DOCS=( CHANGELOG.md DESIGN.md README.md )
SITEFILE="50${PN}-gentoo.el"

src_test() {
	ert-runner -L . -L test --reporter ert+duration --script test || die
}
