# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp

MY_PN="project-emacs--${PN}-mode"
COMMIT="a1361aa154b27bd4db2e1cfe6c3b81b4fc1fdc9a"

DESCRIPTION="A folding-editor-like Emacs minor mode"
HOMEPAGE="https://www.emacswiki.org/emacs/FoldingMode"
SRC_URI="https://github.com/jaalto/${MY_PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="alpha amd64 x86"

S="${WORKDIR}/${MY_PN}-${COMMIT}"
SITEFILE="50${PN}-gentoo.el"
ELISP_TEXINFO="folding.texi"
PATCHES=("${FILESDIR}"/${P}-info-filename.patch)
