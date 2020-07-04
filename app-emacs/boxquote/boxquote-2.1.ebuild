# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp

DESCRIPTION="Quote text with a semi-box"
HOMEPAGE="http://www.davep.org/emacs/"
SRC_URI="https://github.com/davep/${PN}.el/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"

S="${WORKDIR}/${PN}.el-${PV}"
SITEFILE="50${PN}-gentoo.el"
DOCS="README.md"

src_compile() {
	elisp-compile *.el
	elisp-make-autoload-file
}
