# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=pdm-backend
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1 pypi

DESCRIPTION="B2 Python SDK"
HOMEPAGE="
	https://github.com/Backblaze/b2-sdk-python
	https://pypi.org/project/b2sdk/
"
# No tests in sdist
SRC_URI="https://github.com/Backblaze/b2-sdk-python/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}"/b2-sdk-python-${PV}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

# pydantic can be used but it has a fallback
RDEPEND="
	dev-python/logfury[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/pytest-lazy-fixtures[${PYTHON_USEDEP}]
		dev-python/tqdm[${PYTHON_USEDEP}]
	)
"

EPYTEST_IGNORE=(
	# Requires network access and real API keys
	test/integration/test_bucket.py
	test/integration/test_download.py
	test/integration/test_file_version_attributes.py
	test/integration/test_sync.py
	test/integration/test_upload.py
	test/integration/test_raw_api.py
)

distutils_enable_tests pytest
