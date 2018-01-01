# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit vim-plugin git-r3

DESCRIPTION="vim plugin: exheres format highlighting"
HOMEPAGE="http://www.exherbo.org/"
EGIT_REPO_URI="https://git.exherbo.org/git/exheres-syntax.git"

LICENSE="vim"
SLOT="0"
IUSE=""

VIM_PLUGIN_HELPFILES="exheres-syntax"
VIM_PLUGIN_MESSAGES="filetype"

src_prepare() {
	default
	rm .gitignore Makefile || die
}
