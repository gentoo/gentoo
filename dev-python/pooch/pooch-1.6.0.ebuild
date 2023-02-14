# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="Manage your Python library's sample data files"
HOMEPAGE="https://github.com/fatiando/pooch"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~ppc ppc64 ~riscv ~sparc x86"

RDEPEND="
	dev-python/appdirs[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]"

BDEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	test? (
		dev-python/paramiko[${PYTHON_USEDEP}]
		dev-python/pytest-localftpserver[${PYTHON_USEDEP}]
		dev-python/tqdm[${PYTHON_USEDEP}]
	)
"

EPYTEST_DESELECT=(
	# Needs network
	"pooch/tests/test_core.py::test_check_availability_on_ftp"
	"pooch/tests/test_downloaders.py::test_invalid_doi_repository"
	"pooch/tests/test_downloaders.py::test_doi_url_not_found"
	"pooch/tests/test_downloaders.py::test_figshare_url_file_not_found[figshare]"
	"pooch/tests/test_downloaders.py::test_figshare_url_file_not_found[zenodo]"
	"pooch/tests/test_downloaders.py::test_doi_downloader[figshare]"
	"pooch/tests/test_downloaders.py::test_doi_downloader[zenodo]"
)

### docs no included in pypi tarball
# distutils_enable_sphinx doc \
#	dev-python/sphinx-rtd-theme
distutils_enable_tests pytest

export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}

python_test() {
	epytest -k "not network"
}
