# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=27.1

inherit elisp

DESCRIPTION="Child frame doc for Eglot and anything that uses ElDoc"
HOMEPAGE="https://github.com/casouri/eldoc-box"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/casouri/${PN}.git"
else
	SRC_URI="https://github.com/casouri/${PN}/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

BDEPEND="${RDEPEND}"

DOCS=( README.org )
SITEFILE="50${PN}-gentoo.el"

src_compile() {
	elisp-make-autoload-file
	elisp_src_compile
}
