# Copyright 2021-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_VERIFY_REPO=gcp:google-cloud-sdk-py@oss-exit-gate-prod.iam.gserviceaccount.com
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Beautiful, Pythonic protocol buffers"
HOMEPAGE="
	https://github.com/googleapis/proto-plus-python/
	https://pypi.org/project/proto-plus/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	<dev-python/protobuf-8[${PYTHON_USEDEP}]
	>=dev-python/protobuf-3.19.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		>=dev-python/google-api-core-1.31.5[${PYTHON_USEDEP}]
		dev-python/pytz[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest
