# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=26.1

inherit elisp

DESCRIPTION="Linting library for Emacs Lisp package metadata"
HOMEPAGE="https://github.com/purcell/package-lint/"
SRC_URI="https://github.com/purcell/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
KEYWORDS="~amd64 ~x86"
SLOT="0"

PATCHES=( "${FILESDIR}"/${PN}-symbol-info-data-directory.patch )
SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	elisp_src_prepare

	sed "s|@SITEETC@|${EPREFIX}${SITEETC}/${PN}|" -i ${PN}.el || die
}

src_install() {
	elisp-install ${PN} ${PN}{,-flymake}.el{,c}
	elisp-make-site-file "${SITEFILE}"

	insinto ${SITEETC}/${PN}
	doins -r data

	einstalldocs
}
