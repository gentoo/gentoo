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
KEYWORDS="~amd64"

RDEPEND="
	dev-util/patchelf
	virtual/libcrypt:=
"
BDEPEND="
	test? (
		app-arch/rpm
		dev-python/bcrypt[${PYTHON_USEDEP}]
		dev-python/cryptography[${PYTHON_USEDEP}]
		dev-python/openpyxl[${PYTHON_USEDEP}]
		dev-python/pandas[${PYTHON_USEDEP}]
		dev-python/pillow[${PYTHON_USEDEP}]
		dev-python/pydantic[${PYTHON_USEDEP}]
		dev-python/pytest-datafiles[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
		dev-python/pytest-timeout[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	# bug #491602
	"${FILESDIR}/${PN}-6.8.2-buildsystem.patch"
)

distutils_enable_tests pytest

src_prepare() {
	# remove pythonic dep on patchelf exec
	sed -i -e '/patchelf/d' pyproject.toml || die
	# remove repeatedly outdated upper bound on setuptools
	sed -i -e '/setuptools/s:,<[0-9.]*::' pyproject.toml || die
	distutils-r1_src_prepare
}

python_test() {
	# rpm test expects .pyc
	local -x PYTHONDONTWRITEBYTECODE=
	rm -rf cx_Freeze || die
	epytest
}
