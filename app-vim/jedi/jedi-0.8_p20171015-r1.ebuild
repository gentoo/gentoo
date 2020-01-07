# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_6} )

inherit vim-plugin python-r1

# Commit Date: Sun Oct 15 20:51:54 2017 +0200
COMMIT="77924398bd594e238766153cec97ace62650f082"

DESCRIPTION="vim plugin: binding to the autocompletion library jedi"
HOMEPAGE="https://github.com/davidhalter/jedi-vim"
SRC_URI="https://github.com/davidhalter/jedi-vim/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
REQUIRED_USE=${PYTHON_REQUIRED_USE}

RDEPEND="${PYTHON_DEPS}
	dev-python/jedi[${PYTHON_USEDEP}]"
DEPEND="app-editors/vim[python]"

S="${WORKDIR}/jedi-vim-${COMMIT}"

# Tests are broken.
RESTRICT="test"

# Makefile tries hard to call tests so let's silence this phase.
src_compile() { :; }

src_install() {
	vim-plugin_src_install
}
