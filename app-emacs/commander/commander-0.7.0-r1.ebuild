# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Emacs command line parser"
HOMEPAGE="https://github.com/rejeep/commander.el/"
SRC_URI="https://github.com/rejeep/${PN}.el/archive/v${PV}.tar.gz
			-> ${P}.tar.gz"
S="${WORKDIR}"/${PN}.el-${PV}

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	app-emacs/dash
	app-emacs/f
	app-emacs/s
"
BDEPEND="
	${RDEPEND}
	test? (
		app-emacs/ecukes
		app-emacs/el-mock
		app-emacs/ert-runner
		app-emacs/espuds
	)
"

DOCS=( README.md )
SITEFILE="50${PN}-gentoo.el"

src_test() {
	ert-runner || die
	ecukes --debug --reporter spec --script	features || die
}
