# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="Convert XML documents into Python objects"
HOMEPAGE="
	https://github.com/stchris/untangle/
	https://pypi.org/project/untangle/
"
SRC_URI="
	https://github.com/stchris/untangle/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ppc ppc64 ~riscv ~s390 sparc x86"

distutils_enable_tests pytest

RDEPEND="
	>=dev-python/defusedxml-0.7.1[${PYTHON_USEDEP}]
"
