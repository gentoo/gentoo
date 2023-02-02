# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=25.1

inherit elisp

DESCRIPTION="GNU Emacs search tool based on ripgrep"
HOMEPAGE="https://rgel.readthedocs.io/
	https://github.com/dajva/rg.el/"
SRC_URI="https://github.com/dajva/rg.el/archive/${PV}.tar.gz
	-> ${P}.tar.gz"
S="${WORKDIR}"/rg.el-${PV}

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

COMMON_DEPEND="
	app-emacs/transient
	app-emacs/wgrep
"
RDEPEND="
	${COMMON_DEPEND}
	sys-apps/ripgrep
"
BDEPEND="
	${COMMON_DEPEND}
	test? (
		app-emacs/ert-runner
		app-emacs/s
		app-emacs/undercover
	)
"

DOCS=( README.md )
ELISP_REMOVE="test/rg.el-test.el test/rg-isearch.el-test.el"
SITEFILE="50${PN}-gentoo.el"

src_compile() {
	elisp_src_compile
	elisp-make-autoload-file
}

src_test() {
	ert-runner -L . -L test --reporter ert+duration --script test || die
}

src_install() {
	elisp_src_install
	doinfo rgel.info
}
