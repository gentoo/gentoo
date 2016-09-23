# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit vim-plugin

if [[ ${PV} == 9999* ]]; then
	EGIT_REPO_URI="git://github.com/airblade/vim-gitgutter.git"
	inherit git-r3
else
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="vim plugin: shows a git diff in the sign column and stages/reverts hunks"
HOMEPAGE="https://github.com/airblade/vim-gitgutter/"
LICENSE="MIT"
VIM_PLUGIN_HELPFILES="${PN}.txt"

src_prepare() {
	default
	rm README* screenshot.png || die
	rm -rf test || die
}
