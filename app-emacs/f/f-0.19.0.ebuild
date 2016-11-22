# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit elisp

DESCRIPTION="Modern API for working with files and directories in Emacs"
HOMEPAGE="https://github.com/rejeep/f.el"
SRC_URI="https://github.com/rejeep/f.el/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="app-emacs/dash app-emacs/s"
DEPEND="${RDEPEND}"

S="${WORKDIR}/f.el-${PV}"
SITEFILE="50${PN}-gentoo.el"
DOCS="README.md"
