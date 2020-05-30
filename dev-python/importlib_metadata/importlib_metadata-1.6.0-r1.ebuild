# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy3 python{2_7,3_{6,7,8}} )

inherit distutils-r1

DESCRIPTION="Read metadata from Python packages"
HOMEPAGE="https://importlib-metadata.readthedocs.io/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"

RDEPEND="
	dev-python/zipp[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '>=dev-python/configparser-3.5[${PYTHON_USEDEP}]' -2)
	$(python_gen_cond_dep 'dev-python/contextlib2[${PYTHON_USEDEP}]' -2)
	$(python_gen_cond_dep 'dev-python/pathlib2[${PYTHON_USEDEP}]' -2)
"
BDEPEND="
	test? (
		${RDEPEND}
		$(python_gen_cond_dep 'dev-python/importlib_resources[${PYTHON_USEDEP}]' pypy3 python{2_7,3_6})
		dev-python/packaging[${PYTHON_USEDEP}]
		dev-python/pyfakefs[${PYTHON_USEDEP}]
	)
"

distutils_enable_sphinx "${PN}/docs" \
	'>=dev-python/rst-linker-1.9'
distutils_enable_tests unittest

python_prepare_all() {
	# remove dep on setuptools_scm
	sed -i -r "s:use_scm_version=.+,:version='${PV}',:" \
		setup.py || die
	sed -i -e 's:setuptools-scm::' setup.cfg || die

	distutils-r1_python_prepare_all
}
