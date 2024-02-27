# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Python library to generate HTML or XML in a readable, concise and pythonic way"
HOMEPAGE="
	https://www.yattag.org/
	https://github.com/leforestier/yattag/
	https://pypi.org/project/yattag/
"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~riscv ~x86"

distutils_enable_tests unittest

python_test() {
	cd test || die
	eunittest
}
