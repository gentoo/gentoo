# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1

DESCRIPTION="Python client for OpenSearch"
HOMEPAGE="
	https://pypi.org/project/opensearch-py/
	https://github.com/opensearch-project/opensearch-py
"
SRC_URI="
	https://github.com/opensearch-project/opensearch-py/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

# Uses 156 GB of RAM for the test suite, needs more work.
RESTRICT="test"

RDEPEND="
	>=dev-python/urllib3-1.26.19[${PYTHON_USEDEP}]
	>=dev-python/requests-2.32.0[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/certifi[${PYTHON_USEDEP}]
	dev-python/events[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/pytz[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/botocore[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
	)
"
