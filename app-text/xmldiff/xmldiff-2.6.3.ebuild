# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="A tool that figures out the differences between two similar XML files"
HOMEPAGE="
	https://github.com/Shoobx/xmldiff
	https://pypi.org/project/xmldiff/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 ~ia64 ~ppc sparc ~x86 ~x86-linux"

RDEPEND="
	>=dev-python/lxml-3.1.0[${PYTHON_USEDEP}]
"

DOCS=( CHANGES.rst README.rst )

distutils_enable_tests unittest
