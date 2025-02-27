# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 pypy3_11 python3_{10..12} )

inherit distutils-r1

DESCRIPTION="Removes commented-out code from Python files"
HOMEPAGE="
	https://github.com/PyCQA/eradicate/
	https://pypi.org/project/eradicate/
"
SRC_URI="
	https://github.com/PyCQA/eradicate/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ppc ppc64 ~riscv ~s390 sparc x86"

distutils_enable_tests unittest
