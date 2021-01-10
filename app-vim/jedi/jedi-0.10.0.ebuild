# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit vim-plugin python-single-r1

DESCRIPTION="vim plugin: binding to the autocompletion library jedi"
HOMEPAGE="https://github.com/davidhalter/jedi-vim"
SRC_URI="https://github.com/davidhalter/jedi-vim/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="test"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep 'dev-python/jedi[${PYTHON_MULTI_USEDEP}]')
	app-editors/vim[python]"
BDEPEND="${PYTHON_DEPS}
	test? ( dev-python/pytest )"

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
