# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="The missing hash table library for Emacs"
HOMEPAGE="https://github.com/Wilfred/ht.el"
SRC_URI="https://github.com/Wilfred/ht.el/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/ht.el-${PV}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=app-emacs/dash-2.12.0
"
BDEPEND="
	${RDEPEND}
	test? (
		app-emacs/f
		app-emacs/ert-runner
	)
"

DOCS="CHANGELOG.md README.md"
SITEFILE="50${PN}-gentoo.el"

src_test() {
	ert-runner --reporter ert+duration --script || die
}
