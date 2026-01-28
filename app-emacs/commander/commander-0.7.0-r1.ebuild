# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp edo

DESCRIPTION="Emacs command line parser"
HOMEPAGE="https://github.com/rejeep/commander.el/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/rejeep/${PN}.el.git"
else
	SRC_URI="https://github.com/rejeep/${PN}.el/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}/${PN}.el-${PV}"

	KEYWORDS="~alpha amd64 arm arm64 ~loong ppc64 ~riscv ~sparc x86"
fi

LICENSE="GPL-3+"
SLOT="0"
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

ELISP_REMOVE="
	features/usage.feature
"

DOCS=( README.md )
SITEFILE="50${PN}-gentoo.el"

src_test() {
	edo ert-runner
	edo ecukes --debug --reporter spec --script --verbose features
}
