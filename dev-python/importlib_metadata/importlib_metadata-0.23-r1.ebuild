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
KEYWORDS="~alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 sparc x86"
IUSE="test"

RDEPEND="
	dev-python/zipp[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '>=dev-python/configparser-3.5[${PYTHON_USEDEP}]' -2)
	$(python_gen_cond_dep 'dev-python/contextlib2[${PYTHON_USEDEP}]' -2)
	$(python_gen_cond_dep 'dev-python/pathlib2[${PYTHON_USEDEP}]' -2)
"
BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		$(python_gen_cond_dep 'dev-python/importlib_resources[${PYTHON_USEDEP}]' pypy{,3} python{2_7,3_{5,6}})
		dev-python/packaging[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}/importlib_metadata-0.23-py38.patch"
)

distutils_enable_sphinx "${PN}/docs" \
	'>=dev-python/rst-linker-1.9'
distutils_enable_tests unittest

python_prepare_all() {
	# avoid a setuptools_scm dependency
	sed -i "s:use_scm_version=True:version='${PV}',name='${PN//-/.}':" setup.py || die
	sed -r -i "s:setuptools(_|-)scm[[:space:]]*([><=]{1,2}[[:space:]]*[0-9.a-zA-Z]+|)[[:space:]]*::" \
		setup.cfg || die

	distutils-r1_python_prepare_all
}
