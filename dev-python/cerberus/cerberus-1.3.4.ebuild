# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} pypy3 )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="A lightweight and extensible data-validation library for Python"
HOMEPAGE="https://docs.python-cerberus.org/"
SRC_URI="https://github.com/pyeve/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="amd64 ~x86"

PATCHES=(
	"${FILESDIR}"/${PN}-1.3.2_no-pytest-runner.patch
	"${FILESDIR}"/${PN}-1.3.4-raw_docstrings.patch
)

# Require currently unpackaged pytest-benchmark, more useful to developers than to end users.
EPYTEST_DESELECT=(
		cerberus/benchmarks/
)

distutils_enable_tests pytest
