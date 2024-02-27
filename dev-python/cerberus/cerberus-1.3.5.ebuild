# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} pypy3 )

inherit distutils-r1

DESCRIPTION="A lightweight and extensible data-validation library for Python"
HOMEPAGE="
	https://docs.python-cerberus.org/
	https://github.com/pyeve/cerberus/
	https://pypi.org/project/Cerberus/
"
SRC_URI="
	https://github.com/pyeve/cerberus/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86"

PATCHES=(
	"${FILESDIR}"/${PN}-1.3.4-raw_docstrings.patch
)

EPYTEST_DESELECT=(
	# Require currently unpackaged pytest-benchmark, more useful
	# to developers than to end users.
	cerberus/benchmarks/
)

distutils_enable_tests pytest
