# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="A simple statsd client"
HOMEPAGE="
	https://github.com/jsocol/pystatsd/
	https://pypi.org/project/statsd/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~riscv x86 ~amd64-linux ~x86-linux"

distutils_enable_tests pytest

python_test() {
	epytest statsd/tests.py
}
