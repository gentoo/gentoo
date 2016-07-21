# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit vim-plugin git-2

DESCRIPTION="vim plugin: exheres format highlighting"
HOMEPAGE="http://www.exherbo.org/"
EGIT_REPO_URI="git://git.exherbo.org/${PN}.git
	http://git.exherbo.org/pub/scm/${PN}.git"
unset SRC_URI

LICENSE="vim"
SLOT="0"
IUSE=""
KEYWORDS=""

VIM_PLUGIN_HELPFILES="exheres-syntax"
VIM_PLUGIN_MESSAGES="filetype"

src_unpack() {
	git-2_src_unpack
	cd "${S}"
	rm .gitignore Makefile
}

src_compile() {
	:
}
