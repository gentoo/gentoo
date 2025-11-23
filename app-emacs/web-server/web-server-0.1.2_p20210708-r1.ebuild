# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

COMMIT=6357a1c2d1718778503f7ee0909585094117525b

inherit elisp

DESCRIPTION="Web server running Emacs Lisp handlers"
HOMEPAGE="https://github.com/eschulte/emacs-web-server/"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/eschulte/emacs-${PN}.git"
else
	SRC_URI="https://github.com/eschulte/emacs-${PN}/archive/${COMMIT}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}"/emacs-${PN}-${COMMIT}
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"
PROPERTIES="test_network"
RESTRICT="test"

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
	dodoc doc/${PN}_html/*

	insinto ${SITEETC}/${PN}
	doins -r examples
}
