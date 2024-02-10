# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="RPC stack for Emacs Lisp"
HOMEPAGE="https://github.com/kiwanami/emacs-epc/"
SRC_URI="https://github.com/kiwanami/emacs-epc/archive/${PV}.tar.gz
			-> ${P}.tar.gz"
S="${WORKDIR}"/emacs-${P}

LICENSE="GPL-3+"
KEYWORDS="~amd64 ~x86"
SLOT="0"

RDEPEND="
	app-emacs/ctable
	app-emacs/deferred
"
BDEPEND="${RDEPEND}"

DOCS=( readme.md demo img )
SITEFILE="50${PN}-gentoo.el"

src_test() {
	${EMACS} ${EMACSFLAGS} -L . -l epc.el -l epcs.el -l test-epc.el \
		-f ert-run-tests-batch-and-exit || die "tests failed"
}
