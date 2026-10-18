# Copyright 2021-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit-core
PYPI_VERIFY_REPO="https://github.com/mahmoud/boltons"
PYTHON_COMPAT=( python3_{12..15} python3_{14..15}t )

inherit distutils-r1 pypi

DESCRIPTION="Pure-python utilities in the same spirit as the standard library"
HOMEPAGE="
	https://boltons.readthedocs.io/
	https://github.com/mahmoud/boltons/
	https://pypi.org/project/boltons/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

DOCS=( CHANGELOG.md README.md )
