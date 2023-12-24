# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( pypy3 python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Database of countries, subdivisions, languages, currencies and script"
HOMEPAGE="
	https://github.com/pycountry/pycountry/
	https://pypi.org/project/pycountry/
"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~ia64 ~mips ppc ~ppc64 ~riscv ~s390 ~sparc x86"

distutils_enable_tests pytest

BDEPEND="
	test? (
		dev-python/importlib-metadata[${PYTHON_USEDEP}]
	)
"
