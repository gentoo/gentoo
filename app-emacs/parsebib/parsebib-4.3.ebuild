# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=25.1

inherit elisp

DESCRIPTION="Emacs Lisp library for reading .bib files"
HOMEPAGE="https://github.com/joostkremers/parsebib/"
SRC_URI="https://github.com/joostkremers/${PN}/archive/${PV}.tar.gz
			-> ${P}.tar.gz"

LICENSE="BSD"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="test? ( app-emacs/ert-runner )"

DOCS=( README.md )
SITEFILE="50${PN}-gentoo.el"

src_test() {
	ert-runner -L . -L test --reporter ert+duration --script test || die
}
