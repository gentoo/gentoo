# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Emacs major modes for editing Git configuration files"
HOMEPAGE="https://github.com/magit/git-modes/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/magit/${PN}.git"
else
	SRC_URI="https://github.com/magit/${PN}/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="
	>=app-emacs/compat-29.1.4.5
"
BDEPEND="
	${RDEPEND}
"

DOCS=( README.org )
SITEFILE="50${PN}-gentoo.el"

src_compile() {
	elisp_src_compile

	elisp-make-autoload-file
}
