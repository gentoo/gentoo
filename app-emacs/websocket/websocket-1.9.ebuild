# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
NEED_EMACS=24

inherit elisp

DESCRIPTION="A websocket implementation in elisp"
HOMEPAGE="https://github.com/ahyatt/emacs-websocket"
SRC_URI="https://github.com/ahyatt/emacs-${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/emacs-${P}"

src_compile() {
	elisp-compile websocket.el
}

src_test() {
	${EMACS} ${EMACSFLAGS} -L . -l websocket-test \
		-f ert-run-tests-batch-and-exit
}

src_install() {
	elisp-install ${PN} websocket.{el,elc}
	dodoc README.org websocket-functional-test.el testserver.py
}
