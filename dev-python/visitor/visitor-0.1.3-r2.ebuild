# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 pypy3_11 python3_{10..13} )

inherit distutils-r1

DESCRIPTION="A tiny pythonic visitor implementation"
HOMEPAGE="
	https://github.com/mbr/visitor/
	https://pypi.org/project/visitor/
"
# PyPI tarballs don't include tests
# https://github.com/mbr/visitor/pull/2
SRC_URI="
	https://github.com/mbr/visitor/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

distutils_enable_tests pytest
