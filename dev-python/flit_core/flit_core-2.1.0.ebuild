# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7,8} pypy3 )
inherit distutils-r1

DESCRIPTION="Simplified packaging of Python modules (core module)"
HOMEPAGE="https://pypi.org/project/flit-core/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	dev-python/intreehooks[${PYTHON_USEDEP}]
	dev-python/toml[${PYTHON_USEDEP}]
"
BDEPEND="${RDEPEND}
	test? ( dev-python/testpath[${PYTHON_USEDEP}] )
"

distutils_enable_tests pytest

python_prepare_all() {
	printf -- "from setuptools import setup, find_packages\nsetup(name='${PN//_/-}',version='${PV}',%s)" \
		"packages=find_packages()" > setup.py || die

	# use toml instead of depricated pytoml
	sed -e 's:import pytoml as toml:import toml:' \
		-i flit_core/inifile.py || die
	sed -e 's:pytoml:toml:' \
		-i flit_core/build_thyself.py || die

	distutils-r1_python_prepare_all
}
