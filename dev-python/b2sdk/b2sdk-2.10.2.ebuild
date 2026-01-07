# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=pdm-backend
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1 pypi

DESCRIPTION="Library to access Backblaze B2 cloud storage"
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
	>=dev-python/annotated-types-0.5.0[${PYTHON_USEDEP}]
	>=dev-python/logfury-1.0.1[${PYTHON_USEDEP}]
	>=dev-python/requests-2.9.1[${PYTHON_USEDEP}]
	>=dev-python/tenacity-9.1.2[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		>=dev-python/tqdm-4.5.0[${PYTHON_USEDEP}]
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
	# ... and they fail to import w/ pytest-8.4.1 anyway because of
	# pytest_plugins at non-top-level.
	test/integration
)

EPYTEST_PLUGINS=( pytest-{lazy-fixtures,mock,timeout} )
distutils_enable_tests pytest

export PDM_BUILD_SCM_VERSION=${PV}

python_test() {
	if [[ ${EPYTHON} == python3.14 ]] ; then
		local EPYTEST_DESELECT=(
			# Error message differs w/ 3.14
			test/unit/scan/test_folder_traversal.py::TestFolderTraversal::test_dir_without_exec_permission
		)
	fi

	epytest
}
