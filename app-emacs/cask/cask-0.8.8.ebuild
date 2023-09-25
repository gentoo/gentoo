# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Project management for Emacs package development"
HOMEPAGE="https://github.com/cask/cask/"
SRC_URI="https://github.com/cask/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test"  # Most tests fail

RDEPEND="
	app-emacs/ansi
	app-emacs/commander
	app-emacs/epl
	app-emacs/f
	app-emacs/package-build
	app-emacs/s
	app-emacs/shut-up
"
BDEPEND="${RDEPEND}"

DOCS=( README.org cask_small.png )
PATCHES=(
	"${FILESDIR}"/${PN}-bin-launcher-fix.patch
	"${FILESDIR}"/${PN}-no-bootstrap.patch
)

ELISP_REMOVE="${PN}-bootstrap.el
	package-build-legacy.el package-recipe-legacy.el"
SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	elisp_src_prepare

	sed "s|@SITELISP@|${EPREFIX}${SITELISP}/${PN}|" -i bin/${PN} || die
}

src_install() {
	elisp_src_install

	dobin bin/${PN}
}
