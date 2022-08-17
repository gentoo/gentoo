# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="ELPA server written in Emacs Lisp"
HOMEPAGE="https://github.com/cask/servant/"
SRC_URI="https://github.com/cask/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test"  # Tests fail

RDEPEND="
	app-emacs/ansi
	app-emacs/commander
	app-emacs/dash
	app-emacs/epl
	app-emacs/f
	app-emacs/s
	app-emacs/shut-up
	app-emacs/web-server
"
BDEPEND="${RDEPEND}"

DOCS=( README.md )
PATCHES=( "${FILESDIR}"/${PN}-bin-launcher-fix.patch )
SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	elisp_src_prepare

	sed "s|@SITELISP@|${EPREFIX}${SITELISP}/${PN}|" -i bin/${PN} || die
}

src_install() {
	elisp_src_install

	dobin bin/${PN}
}
