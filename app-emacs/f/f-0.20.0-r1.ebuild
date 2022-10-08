# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Modern API for working with files and directories in Emacs"
HOMEPAGE="https://github.com/rejeep/f.el"
SRC_URI="https://github.com/rejeep/f.el/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~ppc64 ~riscv x86"
RESTRICT="test"

RDEPEND="app-emacs/dash app-emacs/s"
DEPEND="${RDEPEND}"

S="${WORKDIR}/f.el-${PV}"
SITEFILE="50${PN}-gentoo.el"
DOCS="README.md"
