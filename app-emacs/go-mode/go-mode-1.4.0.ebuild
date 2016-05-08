# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit elisp

DESCRIPTION="An improved Go mode for emacs"
HOMEPAGE="https://github.com/dominikh/go-mode.el"
SRC_URI="https://github.com/dominikh/go-mode.el/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

S="${WORKDIR}/go-mode.el-${PV}"
SITEFILE="50${PN}-gentoo.el"
DOCS="AUTHORS README.md"
