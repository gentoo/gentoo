# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..13} )

inherit distutils-r1 pypi

DESCRIPTION="Make asyncore available for Python 3.12 onwards"
HOMEPAGE="
	https://github.com/simonrob/pyasyncore
	https://pypi.org/project/pyasyncore/
"

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ppc ppc64 ~riscv ~s390 sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? (
		dev-python/test[${PYTHON_USEDEP}]
	)
"

python_test() {
	# Can't use d_e_t unittest (bug #926964)
	eunittest tests
}
