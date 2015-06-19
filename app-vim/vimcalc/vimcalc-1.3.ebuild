# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/vimcalc/vimcalc-1.3.ebuild,v 1.4 2011/12/11 09:15:29 phajdan.jr Exp $

EAPI="4"

inherit vim-plugin

DESCRIPTION="vim plugin: provides an interactive calculator inside vim"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=3329"
SRC_URI="http://www.vim.org/scripts/download_script.php?src_id=15317 -> ${P}.zip"
LICENSE="vim"
KEYWORDS="amd64 x86"
IUSE=""

VIM_PLUGIN_HELPFILES="vimcalc"

DEPEND="app-arch/unzip"
RDEPEND="|| ( app-editors/vim[python] app-editors/gvim[python] )
	=dev-lang/python-2*"

S="${WORKDIR}/${PN}-v${PV}"

src_prepare() {
	# Remove .DS_Store files that should not be installed
	find -type f -name '.*' -exec rm -f {} + || die
}
