# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} pypy3 )
inherit distutils-r1 pypi

DESCRIPTION="Making it easy to write async iterators in Python 3.5"
HOMEPAGE="https://github.com/python-trio/async_generator https://pypi.org/project/async_generator/"

LICENSE="|| ( MIT Apache-2.0 )"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-macos"

DOCS=( README.rst )

distutils_enable_tests pytest

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest
}
