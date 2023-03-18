# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
inherit distutils-r1 pypi

DESCRIPTION="A non-validating SQL parser module for Python"
HOMEPAGE="https://github.com/andialbrecht/sqlparse"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"
LICENSE="BSD-2"

distutils_enable_sphinx docs/source
distutils_enable_tests pytest
