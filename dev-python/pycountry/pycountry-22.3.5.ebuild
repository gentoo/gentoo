# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Database of countries, subdivisions, languages, currencies and script"
HOMEPAGE="
	https://github.com/flyingcircusio/pycountry/
	https://pypi.org/project/pycountry/
"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~ia64 ~mips ppc ~ppc64 ~riscv ~sparc x86"

RDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
BDEPEND="${RDEPEND}"

distutils_enable_tests pytest

# https://github.com/flyingcircusio/pycountry/pull/51
PATCHES=(
	"${FILESDIR}/pycountry-22.3.5-fix-tests-for-pypy3.patch"
)
