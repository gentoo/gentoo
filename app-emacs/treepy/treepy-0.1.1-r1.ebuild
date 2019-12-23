# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
NEED_EMACS=24

inherit elisp

DESCRIPTION="Generic tree traversing tools for Emacs Lisp"
HOMEPAGE="https://github.com/volrath/treepy.el"
SRC_URI="https://github.com/volrath/treepy.el/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}.el-${PV}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

PATCHES=("${FILESDIR}"/${P}-cl-lib.patch)
SITEFILE="50${PN}-gentoo.el"
DOCS="README.md"
