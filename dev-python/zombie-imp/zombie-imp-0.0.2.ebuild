# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_12 )
inherit distutils-r1 pypi

DESCRIPTION="Copy of the imp module that was removed in Python 3.12 (usage is discouraged)"
HOMEPAGE="https://github.com/encukou/zombie-imp/"

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="~amd64"

# causes invalid BDEPEND with empty test? ( ) if >=python-3.12-only
# (TODO: fix in eclass, but calling or not makes no difference here)
#distutils_enable_tests unittest

python_test() {
	eunittest test_zombie_imp
}
