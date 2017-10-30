# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_4 )

inherit vim-plugin python-r1 python-utils-r1

# Commit Date: Sun Oct 15 20:51:54 2017 +0200
COMMIT="77924398bd594e238766153cec97ace62650f082"

DESCRIPTION="Jedi Python autocompletion with VIM"
HOMEPAGE="https://github.com/davidhalter/jedi-vim"
SRC_URI="https://github.com/davidhalter/jedi-vim/archive/${COMMIT}.zip"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-python/jedi[${PYTHON_USEDEP}]"
DEPEND="app-editors/vim[python]"

S="${WORKDIR}/jedi-vim-${COMMIT}"

#Makeflile calls tests, which are broken.
src_compile() { :; }

src_install() {
	vim-plugin_src_install
}
