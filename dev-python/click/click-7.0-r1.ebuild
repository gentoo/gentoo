# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_{5,6,7,8}} pypy{,3} )

inherit distutils-r1

DESCRIPTION="A Python package for creating beautiful command line interfaces"
SRC_URI="https://github.com/pallets/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
HOMEPAGE="https://palletsprojects.com/p/click/ https://pypi.org/project/click/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE="doc examples"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( $(python_gen_any_dep '
			>=dev-python/docutils-0.14[${PYTHON_USEDEP}]
			dev-python/pallets-sphinx-themes[${PYTHON_USEDEP}]
			>=dev-python/sphinx-1.7.5-r1[${PYTHON_USEDEP}]
		')
	)"

distutils_enable_tests pytest

python_check_deps() {
	use doc || return 0
	has_version ">=dev-python/docutils-0.14[${PYTHON_USEDEP}]" && \
		has_version "dev-python/pallets-sphinx-themes[${PYTHON_USEDEP}]" && \
		has_version ">=dev-python/sphinx-1.7.5-r1[${PYTHON_USEDEP}]"
}

python_prepare_all() {
	# Prevent un-needed d'loading
	sed -e "s/, 'sphinx.ext.intersphinx'//" -i docs/conf.py || die
	distutils-r1_python_prepare_all
}

python_compile_all() {
	use doc && emake -C docs html
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )
	use examples && dodoc -r examples
	distutils-r1_python_install_all
}
