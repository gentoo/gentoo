# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit elisp

DESCRIPTION="desktop+ extends standard desktop module"
HOMEPAGE="https://github.com/ffevotte/desktop-plus"
SRC_URI="https://github.com/ffevotte/desktop-plus/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="app-emacs/dash app-emacs/f"
DEPEND="${RDEPEND}"

S="${WORKDIR}/desktop-plus-${PV}"
SITEFILE="50${PN}-gentoo.el"
DOCS="README.md"

src_compile() {
	elisp-compile *.el
	elisp-make-autoload-file
}
