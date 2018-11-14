# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vim-plugin

DESCRIPTION="vim plugin: gitolite syntax highlighting"
HOMEPAGE="https://github.com/tmatilai/gitolite.vim"
LICENSE="Apache-2.0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

GIT_COMMITSH="990634e95f209ffca96970da1c117c0f67697d89"
SRC_URI="https://github.com/tmatilai/gitolite.vim/archive/${GIT_COMMITSH}.tar.gz -> ${P}.tar.gz"
VIM_PLUGIN_HELPTEXT="Vim Syntax highlight for gitolite configuration file gitolite.conf"

S="${WORKDIR}/gitolite.vim-${GIT_COMMITSH}"

src_compile() {
	:
}
