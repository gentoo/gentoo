# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Simple downloader with an customizable progressbar"
HOMEPAGE="https://github.com/deepjyoti30/downloader-cli/
	https://pypi.org/project/downloader-cli/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND="
	dev-python/urllib3[${PYTHON_USEDEP}]
"

EPYTEST_DESELECT=(
	tests/test_download.py::test__preprocess_conn
	tests/test_download.py::test_file_integrity
)

distutils_enable_tests pytest
