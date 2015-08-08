# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit vim-plugin git-r3

EGIT_REPO_URI="git://github.com/airblade/vim-gitgutter.git"

DESCRIPTION="vim plugin: shows a git diff summary in the sign column and stages/reverts individual hunks"
HOMEPAGE="https://github.com/airblade/vim-gitgutter/"
LICENSE="MIT"
VIM_PLUGIN_HELPFILES="${PN}.txt"

src_prepare() {
	rm README* screenshot.png || die
}
