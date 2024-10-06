# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="GNU Emacs search tool based on ripgrep"
HOMEPAGE="https://rgel.readthedocs.io/
	https://github.com/dajva/rg.el/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/dajva/rg.el.git"
else
	SRC_URI="https://github.com/dajva/rg.el/archive/${PV}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}/rg.el-${PV}"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

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
		app-emacs/s
		app-emacs/undercover
	)
"

ELISP_REMOVE="
	test/rg.el-test.el
	test/rg-isearch.el-test.el
"

DOCS=( README.md )
SITEFILE="50${PN}-gentoo.el"

elisp-enable-tests ert-runner test

src_compile() {
	elisp_src_compile
	elisp-make-autoload-file
}

src_install() {
	elisp_src_install
	doinfo rgel.info
}
