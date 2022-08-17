# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

H=6357a1c2d1718778503f7ee0909585094117525b
NEED_EMACS=24.1

inherit elisp

DESCRIPTION="Web server running Emacs Lisp handlers"
HOMEPAGE="https://github.com/eschulte/emacs-web-server/"
SRC_URI="https://github.com/eschulte/emacs-${PN}/archive/${H}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/emacs-${PN}-${H}

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="sys-apps/texinfo"

DOCS=( README NOTES )
SITEFILE="50${PN}-gentoo.el"

src_compile() {
	elisp_src_compile

	emake -C doc
}

src_test() {
	emake EMACS=${EMACS} check
}

src_install() {
	elisp_src_install

	doinfo doc/${PN}.info
	dodoc -r doc/${PN}

	insinto ${SITEETC}/${PN}
	doins -r examples
}
