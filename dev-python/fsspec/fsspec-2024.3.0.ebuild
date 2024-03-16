# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

MY_P=filesystem_spec-${PV}
DESCRIPTION="A specification that python filesystems should adhere to"
HOMEPAGE="
	https://github.com/fsspec/filesystem_spec/
	https://pypi.org/project/fsspec/
"
SRC_URI="
	https://github.com/fsspec/filesystem_spec/archive/${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"

BDEPEND="
	test? (
		dev-python/aiohttp[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/tqdm[${PYTHON_USEDEP}]
		dev-vcs/git
	)
"

# Note: this package is not xdist-friendly
distutils_enable_tests pytest

src_test() {
	git config --global user.email "you@example.com" || die
	git config --global user.name "Your Name" || die
	distutils-r1_src_test
}

python_test() {
	local EPYTEST_DESELECT=(
		fsspec/tests/test_spec.py::test_find
		# requires s3fs
		fsspec/implementations/tests/test_local.py::test_urlpath_inference_errors
		fsspec/tests/test_core.py::test_mismatch
		# requires pyarrow, fastparquet
		fsspec/implementations/tests/test_reference.py::test_df_single
		fsspec/implementations/tests/test_reference.py::test_df_multi
	)

	local EPYTEST_IGNORE=(
		# sftp and smb require server started via docker
		fsspec/implementations/tests/test_dbfs.py
		fsspec/implementations/tests/test_sftp.py
		fsspec/implementations/tests/test_smb.py
		# unhappy about dev-python/fuse-python (?)
		fsspec/tests/test_fuse.py
	)

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest -p asyncio -p pytest_mock -o tmp_path_retention_policy=all
}
