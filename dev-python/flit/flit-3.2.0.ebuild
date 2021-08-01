# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..10} pypy3 )
inherit distutils-r1

DESCRIPTION="Simplified packaging of Python modules"
HOMEPAGE="https://github.com/takluyver/flit https://flit.readthedocs.io/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	>=dev-python/flit_core-3.2.0[${PYTHON_USEDEP}]
	dev-python/intreehooks[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/requests_download[${PYTHON_USEDEP}]
	dev-python/toml[${PYTHON_USEDEP}]
"
BDEPEND="${RDEPEND}
	sys-apps/grep
	sys-apps/findutils
	test? (
		dev-python/responses[${PYTHON_USEDEP}]
		dev-python/testpath[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}/flit-3.2.0-tests.patch"
)

distutils_enable_tests pytest
distutils_enable_sphinx doc \
	dev-python/sphinxcontrib-github-alt \
	dev-python/pygments-github-lexers \

python_prepare_all() {
	printf -- "from setuptools import setup, find_packages\nsetup(name='%s',version='%s',%s)" \
		"${PN}" "${PV}" "packages=find_packages(exclude=['tests'])" > setup.py || die

	distutils-r1_python_prepare_all
}
