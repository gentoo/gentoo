# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=27.1

inherit elisp

DESCRIPTION="Completion At Point Extensions"
HOMEPAGE="https://github.com/minad/cape/"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/minad/${PN}.git"
else
	SRC_URI="https://github.com/minad/${PN}/archive/refs/tags/${PV}.tar.gz
		-> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="
	>=app-emacs/compat-29.1.4.0
"
DEPEND="
	${RDEPEND}
"

DOCS=( CHANGELOG.org README.org )
ELISP_TEXINFO="${PN}.texi"
SITEFILE="50${PN}-gentoo.el"

src_compile() {
	elisp-org-export-to texinfo README.org
	elisp_src_compile
	elisp-make-autoload-file
}
