# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYPI_VERIFY_REPO=https://github.com/pallets/click
PYTHON_COMPAT=( python3_{11..14} python3_{13,14}t pypy3_11 )

inherit distutils-r1 pypi

DESCRIPTION="A Python package for creating beautiful command line interfaces"
HOMEPAGE="
	https://palletsprojects.com/p/click/
	https://github.com/pallets/click/
	https://pypi.org/project/click/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos"

distutils_enable_sphinx docs \
	'>=dev-python/docutils-0.14' \
	dev-python/myst-parser \
	dev-python/pallets-sphinx-themes \
	dev-python/sphinxcontrib-log-cabinet \
	dev-python/sphinx-tabs

EPYTEST_PLUGINS=()
distutils_enable_tests pytest
