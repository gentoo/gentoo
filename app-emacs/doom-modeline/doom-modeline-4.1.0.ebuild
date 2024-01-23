# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Fancy and fast mode-line for Emacs inspired by minimalism design"
HOMEPAGE="https://seagle0128.github.io/doom-modeline/
	https://github.com/seagle0128/doom-modeline/"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/seagle0128/${PN}.git"
else
	SRC_URI="https://github.com/seagle0128/${PN}/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

DOCS=( README.md )
SITEFILE="50${PN}-gentoo.el"

RDEPEND="
	app-emacs/compat
	app-emacs/nerd-icons
	app-emacs/shrink-path
"
BDEPEND="${RDEPEND}"

elisp-enable-tests ert test

src_compile() {
	elisp_src_compile
	elisp-make-autoload-file
}
