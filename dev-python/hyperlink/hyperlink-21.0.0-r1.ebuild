# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="A featureful, correct URL for Python"
HOMEPAGE="
	https://github.com/python-hyper/hyperlink/
	https://pypi.org/project/hyperlink/
"

LICENSE="BSD MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~x64-macos"

RDEPEND="
	dev-python/idna[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

python_test() {
	# suppresses hypothesis health checks
	local -x CI=1
	epytest
}
