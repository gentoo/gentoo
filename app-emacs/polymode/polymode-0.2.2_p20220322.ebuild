# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

COMMIT=2094c92403fe395dfb2b8b2521da1012a966e9ab
NEED_EMACS=25

inherit elisp

DESCRIPTION="Framework for Multiple Major Modes in Emacs"
HOMEPAGE="https://github.com/polymode/polymode/"
SRC_URI="https://github.com/polymode/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-${COMMIT}

LICENSE="GPL-3+"
KEYWORDS="~amd64 ~x86"
SLOT="0"

DOCS=( readme.md )
# The "compat-tests" downloads resources from network and "define-tests" fails
ELISP_REMOVE="tests/compat-tests.el tests/define-tests.el"
SITEFILE="50${PN}-gentoo.el"

src_test() {
	${EMACS} ${EMACSFLAGS} -L . --load targets/test.el
}

src_install() {
	elisp_src_install

	dodoc -r samples
}
