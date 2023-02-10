# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Python Rate-Limiter using Leaky-Bucket Algorimth Family"
HOMEPAGE="
	https://github.com/vutran1710/PyrateLimiter/
	https://pypi.org/project/pyrate-limiter/
"
SRC_URI="
	https://github.com/vutran1710/PyrateLimiter/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"
S="${WORKDIR}/PyrateLimiter-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/filelock[${PYTHON_USEDEP}]
	dev-python/redis[${PYTHON_USEDEP}]
"

BDEPEND="
	test? (
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
		dev-python/django[${PYTHON_USEDEP}]
		dev-python/django-redis[${PYTHON_USEDEP}]
		dev-python/fakeredis[${PYTHON_USEDEP}]
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
	)
"

EPYTEST_DESELECT=(
	# Optional dependency redis-py-cluster not packaged
	"tests/test_02.py::test_redis_cluster"
	# Python 3.11 is slightly faster, leading to a non-critical failure here
	"tests/test_concurrency.py::test_concurrency[ProcessPoolExecutor-SQLiteBucket]"
)

# TODO: package sphinx-copybutton
# distutils_enable_sphinx docs \
# 	dev-python/sphinx-autodoc-typehints \
# 	dev-python/furo \
# 	dev-python/myst_parser \
# 	dev-python/sphinxcontrib-apidoc
distutils_enable_tests pytest

src_prepare() {
	# workaround installing LICENSE into site-packages
	sed -i -e 's:^include:exclude:' pyproject.toml || die
	distutils-r1_src_prepare
}
