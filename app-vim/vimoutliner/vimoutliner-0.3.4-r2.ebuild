# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit vim-plugin

DESCRIPTION="vim plugin: easy and fast outlining"
HOMEPAGE="http://www.vimoutliner.org/"
SRC_URI="mirror://gentoo/${P}.tar.gz"
LICENSE="GPL-2"
KEYWORDS="alpha amd64 ia64 ~mips ppc sparc x86"
IUSE=""

VIM_PLUGIN_HELPFILES="vimoutliner"
VIM_PLUGIN_MESSAGES="filetype"

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i -e '/^if exists/,/endif/d' ftdetect/vo_base.vim
	sed -i -e 's/g:vo_modules2load/g:vo_modules_load/' vimoutlinerrc
	find "${S}" -type f | xargs chmod a+r
}

src_install() {
	p=/usr/share/vim/vimfiles
	insinto ${p}
	doins -r doc ftdetect ftplugin syntax colors || die "doins failed"

	# Custom vimoutlinerrc so we actually find the plugins
	cp vimoutlinerrc vimoutlinerrc.global
	cat >>vimoutlinerrc.global <<-EOF

	"Gentoo-specific Configuration **************************************
	"Search path for vimoutliner plugins
	setlocal runtimepath+=\$VIM/vimfiles/vimoutliner
	EOF
	newins vimoutlinerrc.global vimoutlinerrc

	insinto ${p}/vimoutliner/plugins
	doins add-ons/plugins/*.vim

	dobin scripts/* add-ons/scripts/*

	dodoc vimoutlinerrc add-ons/plugins/*.otl doc/*
}
