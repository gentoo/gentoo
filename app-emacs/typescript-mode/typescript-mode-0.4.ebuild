# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="TypeScript-support for Emacs"
HOMEPAGE="https://github.com/emacs-typescript/typescript.el/"
SRC_URI="https://github.com/emacs-typescript/typescript.el/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/typescript.el-${PV}

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

SITEFILE="50${PN}-gentoo.el"

elisp-enable-tests ert "${S}" -l typescript-mode-tests.el

src_compile() {
	elisp-compile ${PN}.el
}

src_install() {
	elisp-install ${PN} ${PN}.el{,c}
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"

	dodoc README.md
}
