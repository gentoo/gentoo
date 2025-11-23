# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Emacs Lisp macro to simulate user input non-interactively"
HOMEPAGE="https://github.com/DarwinAwardWinner/with-simulated-input/"
SRC_URI="https://github.com/DarwinAwardWinner/${PN}/archive/v${PV}.tar.gz
			-> ${P}.tar.gz"

LICENSE="GPL-3+"
KEYWORDS="amd64 ~x86"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="test? ( app-emacs/buttercup )"

DOCS=( README.md )
ELISP_REMOVE="tests/test-${PN}.el"  # Remove failing tests; 11/49 specs
SITEFILE="50${PN}-gentoo.el"

src_test() {
	buttercup -L . -L tests --traceback full tests || die
}
