# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=25.1

inherit elisp

DESCRIPTION="Guile's implementation of the Geiser protocols"
HOMEPAGE="https://gitlab.com/emacs-geiser/guile/"
SRC_URI="https://gitlab.com/emacs-geiser/guile/-/archive/${PV}/guile-${PV}.tar.gz
			-> ${P}.tar.gz"
S="${WORKDIR}"/guile-${PV}

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="app-emacs/geiser"
RDEPEND="
	${BDEPEND}
	dev-scheme/guile
"

DOCS=( readme.org )
PATCHES=( "${FILESDIR}"/${PN}-guile-scheme-src-dir.patch )
ELISP_TEXINFO="${PN}.texi"
SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	elisp_src_prepare

	sed "s|@SITEETC@|${EPREFIX}${SITEETC}/${PN}|" -i ${PN}.el || die
}

src_install() {
	elisp_src_install

	insinto ${SITEETC}/${PN}
	doins -r src
}
