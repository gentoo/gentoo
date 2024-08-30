# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( pypy3 python3_{10..13} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 pypi

DESCRIPTION="Easily capture stdout/stderr of the current process and subprocesses"
HOMEPAGE="https://capturer.readthedocs.io/en/latest/
	https://pypi.org/project/capturer/
	https://github.com/xolox/python-capturer"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~x86 ~amd64-linux ~x86-linux"

RDEPEND="dev-python/humanfriendly[${PYTHON_USEDEP}]"

distutils_enable_sphinx docs
distutils_enable_tests pytest

python_test() {
	epytest ${PN}/tests.py
}
