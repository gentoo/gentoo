# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{8..11} )

inherit distutils-r1

DESCRIPTION="A Python library for creating 'editable wheels'"
HOMEPAGE="
	https://pypi.org/project/editables/
	https://github.com/pfmoore/editables/
"
SRC_URI="
	https://github.com/pfmoore/editables/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

distutils_enable_tests pytest
