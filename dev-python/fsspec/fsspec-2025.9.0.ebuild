# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1

MY_P=filesystem_spec-${PV}
DESCRIPTION="A specification that python filesystems should adhere to"
HOMEPAGE="
	https://github.com/fsspec/filesystem_spec/
	https://pypi.org/project/fsspec/
"
# upstream removed tests in 2024.6.0
SRC_URI="
	https://github.com/fsspec/filesystem_spec/archive/${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc64 ~riscv x86"

BDEPEND="
	dev-python/hatch-vcs[${PYTHON_USEDEP}]
	test? (
		dev-python/aiohttp[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/tqdm[${PYTHON_USEDEP}]
		dev-vcs/git
	)
"

# Note: this package is not xdist-friendly
EPYTEST_PLUGINS=( pytest-{asyncio,mock,rerunfailures} )
distutils_enable_tests pytest

export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}

src_test() {
	git config --global user.email "you@example.com" || die
	git config --global user.name "Your Name" || die
	distutils-r1_src_test
}

python_test() {
	local EPYTEST_DESELECT=(
		# Internet
		fsspec/implementations/tests/test_reference.py::test_async_cat_file_ranges
		fsspec/implementations/tests/test_github.py
		fsspec/implementations/tests/test_gist.py
	)

	epytest -o tmp_path_retention_policy=all
}
