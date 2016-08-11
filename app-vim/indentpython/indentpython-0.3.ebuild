# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit vim-plugin

DESCRIPTION="vim plugin: Indent Python code according to PEP8"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=974"
SRC_URI="https://github.com/vim-scripts/${PN}.vim/archive/${PV}.zip -> ${P}.zip"
LICENSE="vim.org"
KEYWORDS="amd64 ppc ppc64 x86"

DEPEND="app-arch/unzip"

S="${WORKDIR}/${PN}.vim-${PV}"
