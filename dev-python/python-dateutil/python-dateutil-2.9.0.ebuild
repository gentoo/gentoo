# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{10..12} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="Extensions to the standard Python datetime module"
HOMEPAGE="
	https://dateutil.readthedocs.io/
	https://pypi.org/project/python-dateutil/
	https://github.com/dateutil/dateutil/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos"

RDEPEND="
	>=dev-python/six-1.5[${PYTHON_USEDEP}]
	sys-libs/timezone-data
"
BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	test? (
		dev-python/freezegun[${PYTHON_USEDEP}]
		dev-python/hypothesis[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}/python-dateutil-2.9.0-system-tzdata.patch"
	"${FILESDIR}/python-dateutil-2.9.0-no-pytest-cov.patch"
)

distutils_enable_tests pytest

python_prepare_all() {
	# don't install zoneinfo tarball
	sed -i '/package_data=/d' setup.py || die

	distutils-r1_python_prepare_all
}
