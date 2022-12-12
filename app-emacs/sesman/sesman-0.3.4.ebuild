# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=25

inherit elisp

DESCRIPTION="Generic session manager for Emacs based IDEs"
HOMEPAGE="https://github.com/vspinu/sesman/"
SRC_URI="https://github.com/vspinu/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md )
SITEFILE="50${PN}-gentoo.el"

src_test() {
	${EMACS} ${EMACSFLAGS} -L . -l ${PN}-test.el    \
		-f ert-run-tests-batch-and-exit || die
}

src_install() {
	rm sesman-test.el* || die

	elisp_src_install
}
