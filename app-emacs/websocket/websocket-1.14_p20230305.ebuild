# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

[[ ${PV} == *_p20230305 ]] && COMMIT=1a08093b122d8cf20366a1cba5faddf7a53d08ed
NEED_EMACS=24

inherit elisp

DESCRIPTION="A websocket implementation in elisp"
HOMEPAGE="https://github.com/ahyatt/emacs-websocket"
SRC_URI="https://github.com/ahyatt/emacs-${PN}/archive/${COMMIT}.tar.gz
	-> ${P}.tar.gz"
S="${WORKDIR}"/emacs-${PN}-${COMMIT}

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DOCS=( README.org websocket-functional-test.el testserver.py )
SITEFILE="50${PN}-gentoo.el"

src_compile() {
	elisp-compile ${PN}.el
}

src_test() {
	${EMACS} ${EMACSFLAGS} -L . -l websocket-test \
		-f ert-run-tests-batch-and-exit || die "tests failed"
}

src_install() {
	elisp-install ${PN} websocket.{el,elc}
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"

	einstalldocs
}
