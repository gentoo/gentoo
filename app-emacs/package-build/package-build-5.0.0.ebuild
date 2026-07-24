# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

inherit elisp

DESCRIPTION="Tools for assembling a package archive"
HOMEPAGE="https://github.com/melpa/package-build/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/melpa/${PN}"
else
	SRC_URI="https://github.com/melpa/${PN}/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="
	>=app-emacs/compat-31.0.0.1
"
BDEPEND="
	${RDEPEND}
"

SITEFILE="50${PN}-gentoo.el"
DOCS=( README.org CHANGELOG )

elisp-enable-tests ert ./test/ -l "./test/${PN}-tests.el"
