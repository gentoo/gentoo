# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PYTHON_COMPAT=( python3_{6,7} )
DISTUTILS_USE_SETUPTOOLS="rdepend"

inherit distutils-r1

DESCRIPTION="Code audit tool for python"
HOMEPAGE="https://github.com/klen/pylama"
SRC_URI="https://github.com/klen/pylama/archive/${PV}.tar.gz -> ${P}.tar.gz"
# pypi tarball excludes unit tests
#SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="
	>=dev-python/mccabe-0.5.2[${PYTHON_USEDEP}]
	dev-python/pycodestyle[${PYTHON_USEDEP}]
	dev-python/pydocstyle[${PYTHON_USEDEP}]
	dev-python/pyflakes[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
	test? (
		dev-python/eradicate[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/radon[${PYTHON_USEDEP}]
	)
"

python_prepare_all() {
	sed -e "s|exclude=\['plugins'\]|exclude=['plugins', 'tests']|" -i setup.py || die
	sed -e 's|^\(def\) \(test_ignore_select\)|\1 _\2|' -i tests/test_config.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	py.test -v tests || die "Tests failed with ${EPYTHON}"
}
