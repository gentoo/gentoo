# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} pypy3 )

inherit distutils-r1

DESCRIPTION="A lightweight and extensible data-validation library for Python"
HOMEPAGE="
	https://docs.python-cerberus.org/
	https://github.com/pyeve/cerberus/
	https://pypi.org/project/Cerberus/
"
SRC_URI="
	https://github.com/pyeve/cerberus/archive/${PV}.tar.gz -> ${P}.tar.gz
"

LICENSE="ISC"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc64 ~riscv ~x86"

PATCHES=(
	"${FILESDIR}"/${PN}-1.3.2_no-pytest-runner.patch
	"${FILESDIR}"/${PN}-1.3.4-raw_docstrings.patch
)

# Require currently unpackaged pytest-benchmark, more useful to developers than to end users.
EPYTEST_DESELECT=(
	cerberus/benchmarks/
)

distutils_enable_tests pytest
