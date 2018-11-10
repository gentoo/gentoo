# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit elisp

DESCRIPTION="Emacs extension to increase selected region by semantic units"
HOMEPAGE="https://github.com/magnars/expand-region.el"
SRC_URI="https://github.com/magnars/expand-region.el/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

S="${WORKDIR}/expand-region.el-${PV}"
SITEFILE="50${PN}-gentoo.el"
DOCS="README.md"

src_compile() {
	elisp-compile *.el
	elisp-make-autoload-file
}
