# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="A collection of yasnippet snippets for many languages"
HOMEPAGE="https://github.com/AndreaCrotti/yasnippet-snippets"
SRC_URI="https://github.com/AndreaCrotti/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="app-emacs/yasnippet"
BDEPEND="${RDEPEND}"

SITEFILE="50${PN}-gentoo.el"

src_compile() {
	${EMACS} ${EMACSFLAGS} --eval "(require 'yasnippet)" \
			 --eval "(yas-compile-directory \"${S}/snippets\")" || die
}

src_install() {
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	insinto "${SITEETC}/${PN}"
	doins -r snippets/.
	dodoc README.md
}
