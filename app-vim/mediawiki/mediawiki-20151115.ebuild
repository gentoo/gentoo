# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vim-plugin

COMMIT_HASH="26e5737264354be41cb11d16d48132779795e168"
DESCRIPTION="vim plugin: MediaWiki syntax highlighting"
HOMEPAGE="https://github.com/chikamichi/mediawiki.vim"
LICENSE="public-domain"
KEYWORDS="~amd64 ~hppa ~mips ~ppc ~ppc64 ~x86"
IUSE=""
SRC_URI="https://github.com/chikamichi/mediawiki.vim/archive/${COMMIT_HASH}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}.vim-${COMMIT_HASH}"

VIM_PLUGIN_HELPTEXT=\
"This holds a syntax highlighter for MediaWiki-based projects, mostly Wikipedia.
Files ending in .wiki will be highlighted."

VIM_PLUGIN_MESSAGES="filetype"
# Same origin, but app-vim/wikipedia-syntax is even less maintained!
RDEPEND="!app-vim/wikipedia-syntax"
