# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{9,10,11,12,13,14} )
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 pypi

DESCRIPTION="Finds file leaks and other security problems on HTTP servers"
HOMEPAGE="https://github.com/hannob/snallygaster"

LICENSE="0BSD"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="dev-python/dnspython
	dev-python/urllib3
	dev-python/lxml"
RDEPEND="${DEPEND}"
DOCS=( README.md TESTS.md )

distutils_enable_tests unittest
