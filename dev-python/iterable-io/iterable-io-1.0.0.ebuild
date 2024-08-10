# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( pypy3 python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="Adapt generators and other iterables to a file-like interface"
HOMEPAGE="
	https://github.com/pR0Ps/iterable-io/
	https://pypi.org/project/iterable-io/
"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64"

distutils_enable_tests pytest
