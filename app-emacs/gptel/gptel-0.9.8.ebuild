# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS="27.1"

inherit elisp

DESCRIPTION="Simple Large Language Model chat client for GNU Emacs"
HOMEPAGE="https://github.com/karthink/gptel/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/karthink/${PN}.git"
else
	SRC_URI="https://github.com/karthink/${PN}/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="~amd64 ~arm64"
fi

LICENSE="GPL-3"
SLOT="0"

RDEPEND="
	>=app-emacs/compat-30.0.0.0
	app-emacs/transient
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
