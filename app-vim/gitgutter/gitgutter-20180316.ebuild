# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit vim-plugin

if [[ ${PV} == 9999* ]]; then
	EGIT_REPO_URI="https://github.com/airblade/vim-gitgutter.git"
	inherit git-r3
else
	inherit vcs-snapshot
	COMMIT_HASH="37bdd03d176c5e182c7e8dbdc79c3f71d2a04898"
	SRC_URI="https://github.com/airblade/vim-gitgutter/archive/${COMMIT_HASH}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 x86"
fi

DESCRIPTION="vim plugin: shows a git diff in the sign column and stages/reverts hunks"
HOMEPAGE="https://github.com/airblade/vim-gitgutter/"
LICENSE="MIT"
VIM_PLUGIN_HELPFILES="${PN}.txt"

RDEPEND="dev-vcs/git"

src_prepare() {
	default

	# remove unwanted files
	rm LICENCE README* screenshot.png unplace.vim || die
	rm -r test || die
}
