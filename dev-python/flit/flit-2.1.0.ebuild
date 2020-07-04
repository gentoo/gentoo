# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} pypy3 )
inherit distutils-r1

DESCRIPTION="Simplified packaging of Python modules"
HOMEPAGE="https://github.com/takluyver/flit https://flit.readthedocs.io/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	dev-python/flit_core[${PYTHON_USEDEP}]
	dev-python/intreehooks[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/requests_download[${PYTHON_USEDEP}]
	dev-python/toml[${PYTHON_USEDEP}]
"
BDEPEND="${RDEPEND}
	sys-apps/grep
	sys-apps/findutils
	test? (
		>=dev-python/pytest-2.7.3[${PYTHON_USEDEP}]
		dev-python/responses[${PYTHON_USEDEP}]
		dev-python/testpath[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}/flit-2.1.0-tests.patch"
)

distutils_enable_tests pytest
distutils_enable_sphinx doc \
	dev-python/sphinxcontrib-github-alt \
	dev-python/pygments-github-lexers \

python_prepare_all() {
	printf -- "from setuptools import setup, find_packages\nsetup(name='%s',version='%s',%s)" \
		"${PN}" "${PV}" "packages=find_packages(exclude=['tests'])" > setup.py || die

	# use toml instead of depricated pytoml
	grep -r -l -Z -F 'pytoml' | xargs -0 \
		sed -e 's:import pytoml as toml:import toml:' \
			-e 's:pytoml:toml:' -i || die

	distutils-r1_python_prepare_all
}
