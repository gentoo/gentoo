# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Collection of Ridiculously Useful eXtensions for GNU Emacs"
HOMEPAGE="https://github.com/bbatsov/crux/"
SRC_URI="https://github.com/bbatsov/${PN}/archive/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DOCS=( CHANGELOG.md CONTRIBUTING.md README.md )
SITEFILE="50${PN}-gentoo.el"

src_compile() {
	elisp_src_compile
	elisp-make-autoload-file
}
