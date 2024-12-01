# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Modern API for working with files and directories in Emacs"
HOMEPAGE="https://github.com/rejeep/f.el/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/rejeep/f.el.git"
else
	SRC_URI="https://github.com/rejeep/f.el/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}/f.el-${PV}"

	KEYWORDS="~alpha amd64 ~arm arm64 ppc64 ~riscv ~sparc x86"
fi

LICENSE="GPL-3+"
SLOT="0"
RESTRICT="test"  # Test dependencies are not ready yet because of KEYWORDS!

RDEPEND="
	app-emacs/dash
	app-emacs/s
"
BDEPEND="
	${RDEPEND}
"
# test? (
#	app-emacs/ert-async
#	app-emacs/undercover
# )

DOCS=( CHANGELOG.org CONTRIBUTING.org README.org )
SITEFILE="50${PN}-gentoo.el"

# elisp-enable-tests ert-runner test
