# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_SETUPTOOLS=pyproject.toml
PYTHON_COMPAT=( python3_{8..10} pypy3 )
inherit distutils-r1

DESCRIPTION="Simplified packaging of Python modules"
HOMEPAGE="https://github.com/takluyver/flit https://flit.readthedocs.io/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/docutils[${PYTHON_USEDEP}]
	>=dev-python/flit_core-3.2.0[${PYTHON_USEDEP}]
	dev-python/intreehooks[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/requests_download[${PYTHON_USEDEP}]
	dev-python/tomli[${PYTHON_USEDEP}]
	dev-python/tomli-w[${PYTHON_USEDEP}]
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
