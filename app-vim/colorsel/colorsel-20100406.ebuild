# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/colorsel/colorsel-20100406.ebuild,v 1.5 2011/01/07 22:20:43 ranger Exp $

EAPI=3

inherit vim-plugin

DESCRIPTION="vim plugin: RGB / HSV color selector"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=927"
SRC_URI="http://www.vim.org/scripts/download_script.php?src_id=12789 -> ${P}.zip"
LICENSE="public-domain"
KEYWORDS="alpha amd64 ia64 ~mips ppc sparc x86"
IUSE=""

VIM_PLUGIN_HELPFILES="${PN}"

DEPEND="app-arch/unzip"
RDEPEND=">=app-editors/gvim-7.0"

S="${WORKDIR}"
