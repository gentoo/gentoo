# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit vim-plugin python-single-r1 vcs-snapshot

DESCRIPTION="vim plugin: resolve conflicts during three-way merges"
HOMEPAGE="https://bitbucket.org/sjl/splice.vim http://vim.sourceforge.net/scripts/script.php?script_id=4026"
SRC_URI="https://bitbucket.org/sjl/${PN}.vim/get/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"
KEYWORDS="amd64 x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="|| ( app-editors/vim[python] app-editors/gvim[python] )"

VIM_PLUGIN_HELPFILES="${PN}.txt"

src_prepare() {
	default
	rm .[a-z]* Makefile LICENSE.markdown package.sh || die
	rm -r site || die
}

src_install() {
	vim-plugin_src_install
	python_optimize "${ED}"/usr/share/vim/vimfiles/autoload/splicelib
}
