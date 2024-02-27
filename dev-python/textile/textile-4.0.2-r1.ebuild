# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

MY_P="python-textile-${PV}"
DESCRIPTION="A Python port of Textile, A humane web text generator"
HOMEPAGE="
	https://github.com/textile/python-textile/
	https://pypi.org/project/textile/
"
SRC_URI="
	https://github.com/textile/python-textile/archive/${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm64 ppc ppc64 ~riscv sparc x86"

RDEPEND="
	dev-python/html5lib[${PYTHON_USEDEP}]
	dev-python/regex[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# tests that need network access
		tests/test_getimagesize.py
		tests/test_imagesize.py
		tests/test_textile.py
	)
	epytest -o addopts=
}
