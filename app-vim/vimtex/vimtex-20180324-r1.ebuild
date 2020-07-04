# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit vim-plugin

if [[ ${PV} == 9999* ]]; then
	EGIT_REPO_URI="https://github.com/lervag/vimtex.git"
	inherit git-r3
else
	inherit vcs-snapshot
	COMMIT_HASH="17d809706edcb277f1ee7fa5e33aff3619926fe4"
	SRC_URI="https://github.com/lervag/vimtex/archive/${COMMIT_HASH}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="vim plugin: a modern vim plugin for editing LaTeX files"
HOMEPAGE="https://github.com/lervag/vimtex"
LICENSE="MIT"

VIM_PLUGIN_HELPFILES="${PN}"

RDEPEND="
	!app-vim/vim-latex
	!app-vim/automatictexplugin"

src_prepare() {
	default

	# remove unwanted files
	rm -r *.md media test || die
}
