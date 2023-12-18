# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Python 2.7 random module ported to Python 3"
HOMEPAGE="https://pypi.org/project/random2/"

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~riscv ~x86"

python_test() {
	"${EPYTHON}" -m unittest -vv src.tests.test_suite ||
		die "Tests failed with ${EPYTHON}"
}
