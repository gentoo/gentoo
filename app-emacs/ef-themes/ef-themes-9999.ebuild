# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Colourful and legible themes for GNU Emacs"
HOMEPAGE="https://github.com/protesilaos/ef-themes/"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/protesilaos/${PN}.git"
else
	SRC_URI="https://github.com/protesilaos/${PN}/archive/${PV}.tar.gz
		-> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

DOCS=( CHANGELOG.org README.md README.org contrast-ratios.org )
ELISP_TEXINFO="${PN}.texi"
SITEFILE="50${PN}-gentoo.el"

src_compile() {
	elisp-org-export-to texinfo README.org

	elisp_src_compile
	elisp-make-autoload-file
}
