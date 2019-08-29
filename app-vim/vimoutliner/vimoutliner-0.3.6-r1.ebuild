# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit vim-plugin

DESCRIPTION="vim plugin: easy and fast outlining"
HOMEPAGE="https://github.com/vimoutliner/vimoutliner"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-2"
KEYWORDS="alpha amd64 ia64 ~mips ppc sparc x86"

VIM_PLUGIN_HELPFILES="vimoutliner"
VIM_PLUGIN_MESSAGES="filetype"

src_prepare() {
	default
	sed -i -e '/^if exists/,/endif/d' ftdetect/vo_base.vim || die
	sed -i -e 's/g:vo_modules2load/g:vo_modules_load/' vimoutliner/vimoutlinerrc || die
	rm -v install.sh || die
	find "${S}" -type f -exec chmod a+r {} \; || die
}
