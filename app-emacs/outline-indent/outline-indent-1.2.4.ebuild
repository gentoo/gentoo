# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

inherit elisp

DESCRIPTION="GNU Emacs package for folding text based on indentation"
HOMEPAGE="https://github.com/jamescherti/outline-indent.el/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/jamescherti/${PN}.el"
else
	SRC_URI="https://github.com/jamescherti/${PN}.el/archive/refs/tags/${PV}.tar.gz
		-> ${P}.gh.tar.gz"
	S="${WORKDIR}/${PN}.el-${PV}"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="
	>=app-emacs/kirigami-1.0.5
"
BDEPEND="
	${RDEPEND}
"

DOCS=( README.md )
SITEFILE="50${PN}-gentoo.el"

ELISP_REMOVE="
	Cask
	Makefile
"

src_compile() {
	elisp_src_compile
	elisp-make-autoload-file
}
