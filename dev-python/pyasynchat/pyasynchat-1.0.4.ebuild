# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..13} )

inherit distutils-r1 pypi

DESCRIPTION="Make asynchat available for Python 3.12 onwards"
HOMEPAGE="
	https://github.com/simonrob/pyasynchat/
	https://pypi.org/project/pyasynchat/
"

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~loong ppc ppc64 ~riscv sparc x86"

RDEPEND="
	>=dev-python/pyasyncore-1.0.2[${PYTHON_USEDEP}]
"

distutils_enable_tests unittest

python_test() {
	eunittest tests
}
