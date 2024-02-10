# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS="27.1"

inherit elisp

DESCRIPTION="Completion kind icons"
HOMEPAGE="https://github.com/jdtsmith/kind-icon/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/jdtsmith/${PN}.git"
else
	SRC_URI="https://github.com/jdtsmith/${PN}/archive/${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="~amd64"
fi

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="
	app-emacs/svg-lib
"
BDEPEND="
	${RDEPEND}
"

SITEFILE="50${PN}-gentoo.el"

src_compile() {
	elisp-make-autoload-file
	elisp_src_compile
}
