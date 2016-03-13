# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit vim-plugin

DESCRIPTION="vim plugin: Managing multiple projects with multiple sources like an IDE"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=69"
SRC_URI="http://www.vim.org/scripts/download_script.php?src_id=6273 -> ${P}.tar.gz"

LICENSE="vim.org"
KEYWORDS="~amd64 ~ppc ~x86"

S=${WORKDIR}

VIM_PLUGIN_HELPFILES="${PN}"
