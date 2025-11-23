# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="An Emacs mode for editing Relax NG compact schema files"
HOMEPAGE="https://github.com/TreeRex/rnc-mode
	https://www.emacswiki.org/emacs/RELAX_NG"
SRC_URI="https://github.com/TreeRex/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"

PATCHES=(
	"${FILESDIR}/${P}-flymake.patch"
	"${FILESDIR}/${P}-font-lock.patch"
)
SITEFILE="50${PN}-gentoo.el"
DOCS="README.md"
