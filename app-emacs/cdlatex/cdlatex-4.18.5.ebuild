# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Fast input methods for LaTeX environments and math"
HOMEPAGE="https://elpa.nongnu.org/nongnu/cdlatex.html"
SRC_URI="https://dev.gentoo.org/~arsen/${P}.tar.xz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	app-emacs/auctex
"
BDEPEND="${RDEPEND}"

ELISP_REMOVE="${PN}-pkg.el"
SITEFILE="50${PN}-gentoo.el"

src_compile() {
	elisp-make-autoload-file
	elisp_src_compile
}
