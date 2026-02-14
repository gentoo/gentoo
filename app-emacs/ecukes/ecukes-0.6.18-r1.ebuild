# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Cucumber for Emacs"
HOMEPAGE="https://github.com/ecukes/ecukes/"
SRC_URI="https://github.com/ecukes/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~loong ppc64 ~riscv ~sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	app-emacs/ansi
	app-emacs/commander
	app-emacs/dash
	app-emacs/espuds
	app-emacs/f
	app-emacs/s
"
BDEPEND="
	${RDEPEND}
	test? (
		app-emacs/el-mock
		app-emacs/ert-runner
	)
"

DOCS=( README.markdown )
PATCHES=( "${FILESDIR}"/${PN}-bin-launcher-fix.patch )

# Remove pkg file and failing tests.
ELISP_REMOVE="
	${PN}-pkg.el
	test/${PN}-parse-line-test.el
	test/${PN}-run-test.el
	test/${PN}-steps-test.el
"
SITEFILE="50${PN}-gentoo.el"

elisp-enable-tests ert-runner test

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

	exeinto /usr/bin
	doexe bin/${PN}
}
