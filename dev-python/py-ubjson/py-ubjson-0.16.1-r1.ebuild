# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="Universal Binary JSON encoder/decoder"
HOMEPAGE="
	https://github.com/Iotic-Labs/py-ubjson/
	https://pypi.org/project/py-ubjson/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~riscv ~sparc x86 ~amd64-linux ~x86-linux"

distutils_enable_tests unittest

python_test() {
	eunittest -s test
}
