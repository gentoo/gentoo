# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="A module to handle standardized numbers and codes"
HOMEPAGE="
	https://arthurdejong.org/python-stdnum/
	https://github.com/arthurdejong/python-stdnum/
	https://pypi.org/project/python-stdnum/
"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 arm64 x86"
IUSE="vies"

RDEPEND="
	vies? (
		|| (
			dev-python/zeep[${PYTHON_USEDEP}]
			dev-python/suds-community[${PYTHON_USEDEP}]
		)
	)
"

distutils_enable_tests pytest

src_prepare() {
	sed -i -e 's:--cov.*::' setup.cfg || die
	distutils-r1_src_prepare
}
