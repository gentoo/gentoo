# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Type hints for Numpy"
HOMEPAGE="
	https://pypi.org/project/nptyping/
	https://github.com/ramonhagenaars/nptyping/
"
SRC_URI="
	https://github.com/ramonhagenaars/nptyping/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/typing-extensions[${PYTHON_USEDEP}]
	' 3.8 3.9)
"
BDEPEND="
	test? (
		dev-python/mypy[${PYTHON_USEDEP}]
		dev-python/typeguard[${PYTHON_USEDEP}]
	)
"

EPYTEST_IGNORE=(
	# TODO: package beartype?
	tests/test_beartype.py
	# relies on Internet access to fetch packages for pip
	tests/test_wheel.py
)

distutils_enable_tests pytest
