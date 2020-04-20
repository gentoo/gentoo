# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{3_6,3_7,3_8} )

inherit vim-plugin python-any-r1

DESCRIPTION="vim plugin: binding to the autocompletion library jedi"
HOMEPAGE="https://github.com/davidhalter/jedi-vim"
SRC_URI="https://github.com/davidhalter/jedi-vim/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="
	${PYTHON_DEPS}
	$(python_gen_any_dep 'dev-python/jedi[${PYTHON_USEDEP}]')
	"
RDEPEND="app-editors/vim[python]"
BDEPEND="test? ( dev-python/pytest )"

S="${WORKDIR}/jedi-vim-${PV}"

# Tests are broken.
RESTRICT="test"

# Makefile tries hard to call tests so let's silence this phase.
src_compile() { :; }

src_install() {
	vim-plugin_src_install
}

src_test() {
	pytest -vv || die
}
