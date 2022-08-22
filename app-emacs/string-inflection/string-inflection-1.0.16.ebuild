# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Convert symbol names between different naming conventions"
HOMEPAGE="https://github.com/akicho8/string-inflection/"
SRC_URI="https://github.com/akicho8/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DOCS=( README.org HISTORY.org )
SITEFILE="50${PN}-gentoo.el"

src_compile() {
	elisp_src_compile
	elisp-make-autoload-file
}

src_test() {
	# "test/string-inflection-test.el" calls "(ert-run-tests-batch t)"
	${EMACS} ${EMACSFLAGS} -L . -L test -l test/${PN}-test.el || die
}
