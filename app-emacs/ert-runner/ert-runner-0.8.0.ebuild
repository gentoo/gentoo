# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Opinionated Emacs Ert testing workflow"
HOMEPAGE="https://github.com/rejeep/ert-runner.el/"
SRC_URI="https://github.com/rejeep/${PN}.el/archive/v${PV}.tar.gz
			-> ${P}.tar.gz"
S="${WORKDIR}"/${PN}.el-${PV}

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~x86"
RESTRICT="test"  # Tests fail (even with Cask installed)

RDEPEND="
	app-emacs/ansi
	app-emacs/commander
	app-emacs/dash
	app-emacs/f
	app-emacs/dash
	app-emacs/shut-up
"
BDEPEND="${RDEPEND}"

DOCS=( README.md )
PATCHES=( "${FILESDIR}"/${PN}-bin-launcher-fix.patch )
SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	elisp_src_prepare

	sed "s|@SITELISP@|${EPREFIX}${SITELISP}/${PN}|" -i bin/${PN} || die
}

src_compile() {
	elisp_src_compile
	elisp-compile reporters/*.el
}

src_install() {
	elisp_src_install
	elisp-install ${PN}/reporters reporters/*.el{,c}

	dobin bin/${PN}
}
