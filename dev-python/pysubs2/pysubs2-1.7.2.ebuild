# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="Python library for editing subtitle files"
HOMEPAGE="
	https://github.com/tkarabela/pysubs2
	https://pypi.org/project/pysubs2/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

distutils_enable_tests pytest
