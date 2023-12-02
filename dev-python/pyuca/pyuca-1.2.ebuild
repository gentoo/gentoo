# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="Python implementation of the Unicode Collation Algorithm"
HOMEPAGE="
	https://github.com/jtauber/pyuca
	https://pypi.org/project/pyuca/
"
SRC_URI="
	https://github.com/jtauber/pyuca/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

distutils_enable_tests unittest
