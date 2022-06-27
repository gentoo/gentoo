# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=24.3

inherit elisp

DESCRIPTION="TypeScript-support for Emacs"
HOMEPAGE="https://github.com/emacs-typescript/typescript.el/"
SRC_URI="https://github.com/emacs-typescript/typescript.el/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/typescript.el-${PV}

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

SITEFILE="50${PN}-gentoo.el"

src_compile() {
	elisp-compile ${PN}.el
}

src_test() {
	${EMACS} ${EMACSFLAGS} -L . -l typescript-mode-tests.el \
			 -f ert-run-tests-batch-and-exit || die
}

src_install() {
	elisp-install ${PN} ${PN}.el{,c}
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"

	dodoc README.md
}
