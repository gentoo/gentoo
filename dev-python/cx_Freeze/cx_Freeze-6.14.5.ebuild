# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..11} )

inherit distutils-r1

DESCRIPTION="Create standalone executables from Python scripts"
HOMEPAGE="
	https://cx-freeze.readthedocs.io/
	https://github.com/marcelotduarte/cx_Freeze/
	https://pypi.org/project/cx-Freeze/
"
SRC_URI="
	https://github.com/marcelotduarte/cx_Freeze/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="PYTHON"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	dev-python/importlib-metadata[${PYTHON_USEDEP}]
	dev-util/patchelf
	virtual/libcrypt:=
"
BDEPEND="
	test? (
		dev-python/bcrypt[${PYTHON_USEDEP}]
		dev-python/cryptography[${PYTHON_USEDEP}]
		dev-python/openpyxl[${PYTHON_USEDEP}]
		dev-python/pandas[${PYTHON_USEDEP}]
		dev-python/pillow[${PYTHON_USEDEP}]
		dev-python/pydantic[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
		dev-python/pytest-timeout[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	# bug #491602
	"${FILESDIR}/${PN}-6.8.2-buildsystem.patch"
)

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# new setuptools?
	tests/test_command_bdist_rpm.py::test_bdist_rpm
)
EPYTEST_IGNORE=(
	# windows-specific test
	tests/test_winversioninfo.py
)
