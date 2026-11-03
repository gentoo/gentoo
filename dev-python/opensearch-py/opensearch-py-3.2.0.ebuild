# Copyright 2023-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_VERIFY_REPO=https://github.com/opensearch-project/opensearch-py
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1 pypi

DESCRIPTION="Python client for OpenSearch"
HOMEPAGE="
	https://pypi.org/project/opensearch-py/
	https://github.com/opensearch-project/opensearch-py
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

# Uses 156 GB of RAM for the test suite, needs more work.
RESTRICT="test"

RDEPEND="
	>=dev-python/urllib3-1.26.19[${PYTHON_USEDEP}]
	>=dev-python/requests-2.32.0[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/certifi[${PYTHON_USEDEP}]
	dev-python/events[${PYTHON_USEDEP}]
"

src_prepare() {
	distutils-r1_src_prepare

	# Not actually used yet
	sed -i -e '/opensearch-protobufs/d' setup.py || die
}
