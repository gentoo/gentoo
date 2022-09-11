# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

H=a6e349e0131f676a885bd14c908fd26054b2df42

inherit elisp

DESCRIPTION="Collection of extensions for Proof General's Coq mode"
HOMEPAGE="https://github.com/cpitclaudel/company-coq/"
SRC_URI="https://github.com/cpitclaudel/${PN}/archive/${H}.tar.gz
		-> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-${H}

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="
	app-emacs/company-math
	app-emacs/company-mode
	app-emacs/dash
	app-emacs/yasnippet
"
RDEPEND="
	${BDEPEND}
	app-emacs/proofgeneral
"

PATCHES=( "${FILESDIR}"/${PN}-refman-path.patch )
SITEFILE="50${PN}-gentoo.el"

src_prepare(){
	default

	sed -i "s|@SITEETC@|${EPREFIX}${SITEETC}|" ./company-coq.el || die
}

src_install() {
	elisp_src_install
	einstalldocs

	insinto "${SITEETC}"
	doins -r ./refman
}
